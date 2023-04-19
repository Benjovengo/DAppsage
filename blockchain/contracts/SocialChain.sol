// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

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
contract SocialChain {
    /**
     * State Variables
     */
    /// The address of the owner of this contract
    address public owner;
    /// Contracts
    MessageData private messageData;
    MessageToken private messageToken;

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

    /**
     * Constructor Method
     */
    constructor(address messageDataContract, address messageTokenContract) {
        owner = msg.sender;
        messageData = MessageData(messageDataContract);
        messageToken = MessageToken(messageTokenContract);
    }
}
