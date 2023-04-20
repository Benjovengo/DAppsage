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
    /// The address of the owner of this contract
    ///     - the owner of this contract is the contract responsible for the logic of the
    address public owner;
    /// Structure for each token's metadata
    struct TokenMetadata {
        uint256 timestamp;
        address composer;
    }
    /// Store the metadata for each token minted
    ///     - the key for the mapping is the token id
    mapping(uint256 => TokenMetadata) public tokenMetadata;

    /**
     * Events
     */
    /// Mint an ERC721 token
    event ERC721TokenCreation(uint256 tokenId, address messageComposer);

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

    /**
     * Mint an NFT for a new tweet
     *
     * @param tokenURI the URI of the message - data stored in IPFS
     * @param messageComposer the blockchain address of the composer of the message
     */
    function mint(
        string memory tokenURI,
        address messageComposer
    ) public onlyOwner {
        // variables
        uint256 newTokenId;
        TokenMetadata memory metadata = TokenMetadata({
            timestamp: block.timestamp,
            composer: messageComposer
        });
        /// Increment the number of tokens
        tokenIds.increment();
        newTokenId = tokenIds.current();
        /// Mint message NFT
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        /// Store the metadata for the token
        tokenMetadata[newTokenId] = metadata;
        /// Emit an event broadcasting the new token Id and the message composer
        emit ERC721TokenCreation(newTokenId, messageComposer);
    }

    /**
     * Function Overrrides
     *
     * @dev Overrides the default functionalities for the ERC721 tokens.
     * @dev This allow developers to customize functions imported from
     * OpenZeppelin's ERC721 smart contract
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721) {
        require(
            msg.sender == owner,
            "Only the contract owner can transfer tweet tokens."
        );
        require(
            to != address(0x0),
            "The token cannot be transferred to address 0x0."
        );
        super._transfer(from, to, tokenId);
    }
}
