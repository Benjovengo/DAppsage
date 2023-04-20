// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

/// Import OpenZeppelin libraries
import "../node_modules/@openzeppelin/contracts/security/Pausable.sol";
/// Import the data smart contracts
import "./MessageData.sol";
import "./MessageToken.sol";

/**
 * @title Social Media Smart Contract
 * @author Fábio Benjovengo
 *
 * Smart contract to manage the messages like tweets in the blockchain.
 *
 * @dev the logic of the social media is separate from the smart contracts to
 * store the data for upgrade (migration) purposes
 *
 * @custom:security Use this contract only for tests! Do NOT store any real
 * information in this project!
 * @custom:security-contact fabio.benjovengo@gmail.com
 */
contract SocialChain is Pausable {
    /**
     * State Variables
     */
    /// The address of the owner of this contract
    address public owner;
    /// Request the token
    /// - in order for someone to receive the ownership of the message,
    ///   this transfer has to be approved by the recipient
    /// - nested mapping:
    ///   recipient (address) => message Id (uint256) => approved to receive? (bool)
    mapping(address => mapping(uint256 => bool)) private recipientApproval;
    /// Contracts
    MessageData private immutable messageData;
    MessageToken private immutable messageToken;

    /**
     * Modifiers
     * @dev only certain entity can call some methods
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    /**
     * Events
     */
    /// Change the owner of the SocialChain smart contract
    event SocialChainChangeOwnership(address newOwner);

    /**
     * Constructor Method
     */
    constructor(address messageDataContract, address messageTokenContract) {
        owner = msg.sender;
        messageData = MessageData(messageDataContract);
        messageToken = MessageToken(messageTokenContract);
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
        /// Emit event for the chang in ownership
        emit SocialChainChangeOwnership(newOwner);
    }

    /**
     * Create and store a new message in the blockchain
     *
     * @param messageComposer the address of the composer of the message
     * @param messageBytes the string for the message
     */
    function createMessage(
        address messageComposer,
        bytes memory messageBytes
    ) public whenNotPaused {
        messageData.storeMessage(messageComposer, messageBytes);
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
        (
            bytes memory textMessage,
            uint256 timestamp,
            address messageComposer,
            address messageOwner
        ) = messageData.fetchMessage(messageId);
        return (textMessage, timestamp, messageComposer, messageOwner);
    }

    /**
     * Approves receiving the ownership of a certain message
     *
     * @param messageId the Id of the message to be received by the msg.sender account
     */
    function requestMessageOwnership(uint256 messageId) public {
        recipientApproval[msg.sender][messageId] = true;
    }

    /**
     * Change the owner of a tweet/message.
     *
     * @param messageId the serial identifier of the tweet/message
     * @param newOwner the new owner of the tweet/message
     *
     * @dev the new owner has to have approved the transfer of ownership before
     * the change otherwise the change will not happen
     */
    function changeMessageOwner(
        uint256 messageId,
        address newOwner
    ) public whenNotPaused {
        require(
            recipientApproval[newOwner][messageId],
            "The message cannot be transferred without the recipient's approval."
        );
        address messageOwner = messageData.getMessageOwner(messageId);
        require(
            messageOwner == msg.sender,
            "Only the owner can transfer the ownership of a message."
        );
        /// Reset the approval to receive the ownership of the message once the ownership has already been granted
        recipientApproval[newOwner][messageId] = false;
        /// Set the new owner
        messageData.setMessageOwner(messageId, newOwner);
    }

    /**
     * Broadcast a new message as an event in the blockchain
     *
     * @param messageComposer the address of the composer of the message
     * @param messageBytes the string for the message
     */
    function broadcastOnly(
        address messageComposer,
        bytes memory messageBytes
    ) public whenNotPaused {
        messageData.publishMessage(messageComposer, messageBytes);
    }

    /**
     * Store a tweet/message as an ERC-721 token
     *
     * @param tokenURI the tweet/message - Uniform Resource Identifier (URI) for the token
     * @param messageComposer the address of the composer of the tweet/message
     */
    function mintERC721Message(
        string memory tokenURI,
        address messageComposer
    ) public {
        messageToken.mint(tokenURI, messageComposer);
    }
}
