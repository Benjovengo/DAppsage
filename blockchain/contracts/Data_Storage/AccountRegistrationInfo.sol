// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// OpenZeppelin Contracts
import "../../node_modules/@openzeppelin/contracts/utils/Counters.sol";

/**
@title Sign In Information
@author Fábio Benjovengo

This contract implements the functions and state variables to store the sign-in
information of user accounts on the blockchain.

The sign-in information is stored in a struct object and includes:
- first name;
- last name;
- URL to the profile picture;
- e-mail contact information.

@dev This contract tracks all the changes in the sign-in information associated
with all the addresses of the accounts in the blockchain, including the date of
registration or changes.

@dev The profile picture is stored in IPFS, and the address of the image in IPFS
is stored in the struct object.

@custom:security Use this contract only for tests! Do NOT use this contract to
manage real ether or send any real information in this project!
@custom:security-contact fabio.benjovengo@gmail.com
*/
contract AccountRegistrationInfo {
    /**
    State Variables
    */
    /// allow to create an ID for each account
    using Counters for Counters.Counter;
    Counters.Counter private newAccountId;
    /// The address of the owner of this contract
    ///     - the owner of this contract is the contract responsible for the
    ///       logic of the BlockCast social platform.
    address public owner;
    /// Structure for each account
    /// - the timestamp field  refers to a variable that holds the time value
    ///   when the struct was created or updated
    struct AccountData {
        bytes firstName;
        bytes lastName;
        bytes email;
        bytes profilePictureURL;
        uint256 timestamp;
        address userAddress;
    }
    // Store the sign-in information for a user
    //     - the key for the mapping is the ID of the information
    mapping(uint256 => AccountData) private accountsSignInData;
    // Array of sign-in information IDs for each user (address)
    // Each time an account is added or updated, a new ID is generated for the
    // struct containing the data, which is then stored in a mapping using the
    // user's address as the key. The ID is added to an array to track
    // modifications made to the account. The most recent data corresponds to the
    // ID stored in the last entry of the array.
    mapping(address => uint256[]) private accountsModifications;

    /**
    Modifiers
    @dev to control the access of calling some methods
    */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    /**
    Events
    */
    /// Change Ownership
    event ChangeOwnership(address newOwner);
    /// Create Account
    event createAccountEvent(uint256 accountID);

    /**
    Constructor Method
    */
    constructor() {
        owner = msg.sender;
    }

    /**
    Create/Update the information for an account.
    - Stores the sign-in information for a user on the blockchain.

    @param userAddress The Ethereum address of the user account.
    @param firstName The first name of the user as a byte array.
    @param lastName The last name of the user as a byte array.
    @param email The email address of the user as a byte array.
    @param profilePictureURL The URL of the user's profile picture stored in
    IPFS as a byte array.
     */
    function addUpdateAccount(
        address userAddress,
        bytes memory firstName,
        bytes memory lastName,
        bytes memory email,
        bytes memory profilePictureURL
    ) public onlyOwner {
        /// Requirements
        require(userAddress != address(0x0), "Cannot sign-in as address 0x0.");
        require(firstName.length != 0, "The message cannot be empty.");
        /// Struct instance
        AccountData memory accountDataStruct = AccountData({
            firstName: firstName,
            lastName: lastName,
            email: email,
            profilePictureURL: profilePictureURL,
            timestamp: block.timestamp,
            userAddress: userAddress
        });
        /// Increment the number of messages
        newAccountId.increment();
        /// Store the registration data
        accountsSignInData[newAccountId.current()] = accountDataStruct;
        /// Add the ID to the list of data modifications to the user
        accountsModifications[userAddress].push(newAccountId.current());
        /// Emit event for publishing a message
        emit createAccountEvent(newAccountId.current());
    }

    /**
    Fetch the latest user information from the blockchain.
    
    @param accountID the unique serial number of the message to be fetched
    
    @return userAddress The Ethereum address of the user account.
    @return firstName The first name of the user as a byte array.
    @return lastName The last name of the user as a byte array.
    @return email The email address of the user as a byte array.
    @return profilePictureURL The URL of the user's profile picture stored in
    IPFS as a byte array.
    @return timestamp Unix Epoch of the time of the registration
    */
    function fetchUserData(
        uint256 accountID
    )
        public
        view
        returns (
            address,
            bytes memory,
            bytes memory,
            bytes memory,
            bytes memory,
            uint256
        )
    {
        AccountData memory userDataStruct = accountsSignInData[accountID];
        return (
            userDataStruct.userAddress,
            userDataStruct.firstName,
            userDataStruct.lastName,
            userDataStruct.email,
            userDataStruct.profilePictureURL,
            userDataStruct.timestamp
        );
    }
}
