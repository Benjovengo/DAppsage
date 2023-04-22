// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

/// Import OpenZeppelin libraries
import "../../node_modules/@openzeppelin/contracts/security/Pausable.sol";
/// Import the data smart contracts
import "../Data_Storage/MessageData.sol";
import "../Data_Storage/MessageToken.sol";

/**
@title Likes and Rewards for Tweets
@author Fábio Benjovengo

Smart contract to manage likes and the reward system.

@dev the logic of the social media is separate from the smart contracts to
store the data for upgrade (migration) purposes

@custom:security Use this contract only for tests! Do NOT use this contract to
manage real ether or send any real ether to this project!
@custom:security-contact fabio.benjovengo@gmail.com
*/
contract RewardLikes is Pausable {

}
