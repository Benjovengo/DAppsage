// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// OpenZeppelin - imports for an ERC-721 token
import "../../node_modules/@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title Messages Data
 * @author Fábio Benjovengo
 *
 * Smart contract to store the messages
 *
 * @dev the data is stored in a separate smart contract to be able to more easily migrate the logic contracts
 * @custom:security Use this contract only for tests! Do NOT store any real information in this project!
 * @custom:security-contact fabio.benjovengo@gmail.com
 */
contract MessageData {
    /**
     * State Variables
     */
    /// The address of the owner of this contract
    ///     - the owner of this contract is the contract responsible for the logic of the
    address private owner;
    /// Create the unique Id for each message
    using Counters for Counters.Counter;
    Counters.Counter private messageIdCounter;
    /// Structure for each message's metadata
    struct MessageCompleteData {
        bytes textMessage;
        uint256 timestamp;
        address composer;
        address owner;
    }
    /// Store the data for each message added to the platform
    ///     - the key for the mapping is the message unique id
    mapping(uint256 => MessageCompleteData) private messageCompleteData;
    /// Store the message for the owners
    ///     - the key is the address of the owner of a message
    ///     - stores an array of Ids of the messages owned by the address
    mapping(address => uint256[]) private ownedMessages;
    /// The index of a message Id in the array of the owned messages.
    ///     - the first key is the address of the owner's account
    ///     - the second key is the Id of the message
    mapping(address => mapping(uint256 => uint256)) private messageIdIndex;
    /// Store the number of likes for each message
    ///     - the key is the Id of the message
    ///     - stores how many likes the message has
    mapping(uint256 => uint256) private numberOfLikes;

    /**
     * Events
     */
    /// Change Ownership
    event ChangeOwnership(address newOwner);
    /// New Message
    event NewMessageBroadcast(uint256 id);
    /// New Message - Event only
    event NewMessageEventBroadcast(address composer, bytes messageBytes);

    /**
     * Modifiers
     * @dev only certain entity can call some methods
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    /**
     * Constructor Method
     */
    constructor() {
        /// set the deployer as the initial owner of this contract
        owner = msg.sender;
    }

    /**
     * Change the ownership of this smart contract
     *
     * @param newOwner the address of the new owner of this smart contract
     * @dev this function is used when migrating to another smart contract for the logic of the messaging platform
     */
    function changeOwner(address newOwner) public onlyOwner {
        require(
            newOwner != address(0x0),
            "The new owner cannot be the address 0x0."
        );
        require(newOwner != owner, "The new owner is the current owner.");
        owner = newOwner;
        emit ChangeOwnership(newOwner);
    }

    /**
     * Store a new message in the blockchain
     *
     * @param messageComposer the address of the composer of the message
     * @param messageBytes the string for the message
     */
    function storeMessage(
        address messageComposer,
        bytes memory messageBytes
    ) public {
        /// Variables
        require(messageBytes.length != 0, "The message cannot be empty.");
        MessageCompleteData memory messageData = MessageCompleteData({
            textMessage: messageBytes,
            timestamp: block.timestamp,
            composer: messageComposer,
            owner: messageComposer
        });
        /// Increment the number of messages
        messageIdCounter.increment();
        /// Store the data for the message
        messageCompleteData[messageIdCounter.current()] = messageData;
        /// Add message to account
        addMessage(messageComposer, messageIdCounter.current());
        /// Emit event for publishing a message
        emit NewMessageBroadcast(messageIdCounter.current());
    }

    /**
     * Fetch a single message from the blockchain
     *
     * @param messageId the unique serial number of the message to be fetched
     * @return textMessage the message in bytes
     * @return timestamp the Unix Epoch time in which the message was stored in the blockchain
     * @return composer the address of the composer of the message
     * @return owner the address of the current owner of the message
     */
    function fetchMessage(
        uint256 messageId
    ) public view returns (bytes memory, uint256, address, address) {
        MessageCompleteData memory singleMessage = messageCompleteData[
            messageId
        ];
        return (
            singleMessage.textMessage,
            singleMessage.timestamp,
            singleMessage.composer,
            singleMessage.owner
        );
    }

    /**
     * Return the owner of a message.
     *
     * @param messageId the unique serial number of the message
     */
    function getMessageOwner(uint256 messageId) public view returns (address) {
        MessageCompleteData memory singleMessage = messageCompleteData[
            messageId
        ];
        return singleMessage.owner;
    }

    /**
     * Set a new owner of a message.
     *
     * @param messageId the unique serial number of the message
     * @param newOwner the new owner of the message
     */
    function setMessageOwner(
        uint256 messageId,
        address newOwner
    ) public onlyOwner {
        require(
            newOwner != address(0x0),
            "The new owner cannot be the address 0x0."
        );
        require(
            messageCompleteData[messageId].owner != address(0x0),
            "The struct has not been defined yet."
        );
        MessageCompleteData storage singleMessage = messageCompleteData[
            messageId
        ];
        singleMessage.owner = newOwner;
    }

    /**
     * Return the total number of messages stored as a blockchain state.
     *
     * @return messageIdCounter the current value of the counter of the unique serial Id for the messages
     */
    function totalNumberOfStoredMessages()
        public
        view
        onlyOwner
        returns (uint256)
    {
        return messageIdCounter.current();
    }

    /**
     * Add a like to a message/tweet.
     *
     * @param messageId the Id (unique serial identifier) of the liked message/tweet.
     */
    function addLike(uint256 messageId) public {
        numberOfLikes[messageId] += 1;
    }

    /**
     * Add a message to an account.
     *  Sets the account as the owner of the message.
     *
     * @param ownerAddress the address of the account to which add the message.
     * @param messageId the Id (unique serial identifier) of themessage/tweet.
     */
    function addMessage(address ownerAddress, uint256 messageId) public {
        ownedMessages[ownerAddress].push(messageId);
        /// Store the index of the new message in the new owner's array
        messageIdIndex[ownerAddress][messageId] =
            ownedMessages[ownerAddress].length -
            1;
    }

    /**
     * Remove a message from an account.
     *
     * @dev Takes the last element of the array and copy its value to the index
     * where the element to be removed is in. Then pop the last element since
     * it has already been copied to another location in the array.
     * @dev This technique ensures that the array keeps the correct length
     * after removing an item.
     *
     * @param ownerAddress the address of the account to which add the message.
     * @param messageId the Id (unique serial identifier) of themessage/tweet.
     */
    function removeMessage(address ownerAddress, uint256 messageId) private {
        /// The index in the owner's array of the desired message to be removed
        uint256 index = messageIdIndex[ownerAddress][messageId];
        /// Copy the last element in the owner's array to the position of the
        /// element to be removed
        ownedMessages[ownerAddress][index] = ownedMessages[ownerAddress][
            ownedMessages[ownerAddress].length - 1
        ];
        /// Update the index for the message
        uint256 lastItemId = ownedMessages[ownerAddress][
            ownedMessages[ownerAddress].length - 1
        ];
        messageIdIndex[ownerAddress][lastItemId] = index;
        /// Remove the last item of the array and reduce its length
        ownedMessages[ownerAddress].pop();
    }

    /**
     * Transfer a message from one accout to another.
     *
     * The currentOwner address has to be the owner of the message.
     *
     * @param currentOwner the address of the current owner of the message.
     * @param newOwner the address of the account to which the message will be
     * transferred to.
     * @param messageId the Id (unique serial identifier) of the message.
     */
    function transferMessageOwnership(
        address currentOwner,
        address newOwner,
        uint256 messageId
    ) public {
        require(
            messageCompleteData[messageId].owner == currentOwner,
            "Only the owner can transfer the message."
        );
        require(
            (newOwner != address(0x0) && currentOwner != address(0x0)),
            "Both the current owner and the new owner cannot be the address 0x0."
        );
        addMessage(newOwner, messageId);
        removeMessage(currentOwner, messageId);
        /// Emit event for publishing a message
        emit NewMessageBroadcast(messageId);
    }

    /**
     * Publish a new message as an event
     *
     * @param messageComposer the address of the composer of the message
     * @param messageBytes the bytes representation of a string for the message
     */
    function publishMessage(
        address messageComposer,
        bytes memory messageBytes
    ) public {
        require(messageBytes.length != 0, "The message cannot be empty.");
        /// Emit event for publishing a message
        emit NewMessageEventBroadcast(messageComposer, messageBytes);
    }
}
