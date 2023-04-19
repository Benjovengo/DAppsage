// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// OpenZeppelin - imports for an ERC-721 token
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

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
    Counters.Counter private messageId;
    /// Structure for each message's metadata
    struct MessageCompleteData {
        bytes textMessage;
        uint256 timestamp;
        address composer;
        address owner;
    }
    /// Store the data for each message added to the platform
    ///     - the key for the mapping is the message unique id
    mapping(uint256 => MessageCompleteData) public messageCompleteData;

    /**
     * Events
     */
    /// Change Ownership
    event ChangeOwnership(address newOwner);
    /// New Message
    event NewMessageBroadcast(address author, string newMessage);

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
        owner = newOwner;
        emit ChangeOwnership(newOwner);
    }

    /**
     * Publish a new message
     *
     * @param messageComposer the address of the composer of the message
     * @param messageString the string for the message
     */
    function publishMessage(
        address messageComposer,
        string memory messageString
    ) public {
        // Variables
        bytes memory strBytes = bytes(messageString);
        require(strBytes.length != 0, "The message cannot be empty.");
        MessageCompleteData memory messageData = MessageCompleteData({
            textMessage: strBytes,
            timestamp: block.timestamp,
            composer: messageComposer,
            owner: messageComposer
        });
        /// Increment the number of messages
        messageId.increment();
        /// Store the data for the message
        messageCompleteData[messageId.current()] = messageData;
        /// Emit event for publishing a message
        emit NewMessageBroadcast(messageComposer, messageString);
    }
}
