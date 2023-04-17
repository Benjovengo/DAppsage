// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

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
contract MessagesData {
    /**
     * State Variables
     */
    /// the address of the owner of this contract
    /// the owner of this contract is the contract responsible for the logic of the
    address private owner;

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
}