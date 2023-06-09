// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "../../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

/**
@title ERC-20 Voting Token - Governance for the social network
@author Fábio Benjovengo

@notice This contract implements the voting token standard.

@dev Use this contract only for tests! Do NOT use this contract to manage real
ether or send any real ether to this project!
@custom:experimental This is an experimental contract.
@custom:security-contact fabio.benjovengo@gmail.com
*/
contract VotingToken is ERC20Votes, Ownable {
    /**
    @dev Initializes the contract with the following parameters:
    
    @notice ERC20Permit standard is used to build applications that
    require conditional transfers of tokens, such as decentralized
    exchanges or governance systems
    */
    constructor()
        ERC20("Tweet Voting Token", "TVT")
        ERC20Permit("Tweet Voting Token")
    {
        _mint(msg.sender, 1_000_000_000_000_000_000_000_000);
    }

    /**
    The following functions are overrides required by Solidity.
        @dev Created by OpenZeppelin Wizard at https://docs.openzeppelin.com/contracts/4.x/wizard
    */

    /// @dev Move voting power when tokens are transferred.
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    /// @dev Snapshots the totalSupply after it has been increased.
    function _mint(address to, uint256 amount) internal override(ERC20Votes) {
        super._mint(to, amount);
    }

    /// @dev Snapshots the totalSupply after it has been decreased.
    function _burn(
        address account,
        uint256 amount
    ) internal override(ERC20Votes) {
        super._burn(account, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC20) {
        require(
            msg.sender == this.owner(),
            "Only the contract owner can transfer voting tokens."
        );
        super._transfer(from, to, tokenId);
    }
}
