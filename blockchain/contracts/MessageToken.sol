// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// OpenZeppelin - imports for NFT (ERC-721 token)
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title Messages Token
 * @author Fábio Benjovengo
 *
 * ERC-721 token to represent unique messages like tweets
 *
 * @dev the ERC721Storage is used to be able to more easily migrate the logic contracts
 * @custom:security Use this contract only for tests! Do NOT store any real information in this project!
 * @custom:security-contact fabio.benjovengo@gmail.com
 */
contract MessageToken is ERC721URIStorage {
    /**
     * State Variables
     */
    /// allow to create an enumerable ERC-721 token
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    /// the address of the owner of this contract
    /// the owner of this contract is the contract responsible for the logic of the
    address public owner;

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
    /// Change Ownership
    event ChangeOwnership(address newOwner);

    /**
     * Constructor Method
     */
    constructor() ERC721("DApp Message Token", "DMSG") {
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
