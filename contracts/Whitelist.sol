// SPDX-License-Identifier: MIT
// < x - + / - x + Test Contract + x - \ + - x >
pragma solidity 0.8.20;

/**
 * @title Whitelist
 * @dev Contract for managing a whitelist of users with direct and referral-based whitelisting.
 */
contract Whitelist {
    // The address that deployed the contract.
    address owner;

    // The address with administrative privileges.
    address admin;

    // Struct to hold whitelist data for each address.
    struct whitelistData {
        bool status; // True if the address is whitelisted.
        address referrer; // The address that referred this user.
    }

    // Mapping of addresses to their whitelist data.
    mapping(address => whitelistData) whitelists;

    // Counter to keep track of the total number of whitelisted users.
    uint counter;

    // Time in seconds a referrer must wait before they can whitelist another user through referrals.
    uint referralCooldown = 30 minutes;

    // Mapping of addresses to the timestamp of their last referral.
    mapping(address => uint) referrerTimeStamp;

    /**
     * @dev Constructor sets the owner of the contract to the address that deployed it.
     */
    constructor() {
        owner = msg.sender;
    }

    // Modifier to restrict access to functions to the owner only.
    modifier ownerOnly() {
        require(msg.sender == owner, "Only Owner of this contract can perform this action!");
        _;
    }

    // Modifier to restrict access to functions to the admin only.
    modifier adminOnly() {
        require(msg.sender == admin, "Only admin of this contract can perform this action!");
        _;
    }

    // Modifier to restrict access to functions to whitelisted users only.
    modifier whitelistedOnly() {
        require(whitelists[msg.sender].status == true, "Only whitelisted users can perform this action!");
        _;
    }

    /**
     * @dev Allows the owner to update the admin address.
     * @param _address The new admin address.
     */
    function updateAdmin(address _address) public ownerOnly {
        require(msg.sender != admin, "admin address already updated");
        admin = _address;
    }

    /**
     * @dev Returns the current admin address.
     * @return The admin address.
     */
    function getAdminAddress() public view returns(address) {
        return admin;
    }

    /**
     * @dev Emitted when an address is directly whitelisted.
     */
    event DirectlyWhitelisted(address indexed user, bool newStatus);

    /**
     * @dev Allows the admin to directly whitelist an address.
     * @param _address The address to be whitelisted.
     * @param _status The new whitelist status.
     */
    function directWhitelist(address _address, bool _status) public adminOnly {
        require(whitelists[_address].status != _status, "Whitelist Status is already updated");
        whitelists[_address].status = _status;
        if (_status == true) {
            counter++;
        } else {
            counter--;
        }

        emit DirectlyWhitelisted(_address, _status);
    }

    /**
     * @dev Emitted when an address is whitelisted through referrals.
     */
    event ReferredWhitelisted(address indexed user, address indexed referrer);

    /**
     * @dev Allows a whitelisted user to whitelist another address through referrals.
     * @param _address The address to be whitelisted.
     */
    function referWhitelist(address _address) public whitelistedOnly {
        require(whitelists[_address].status != true, "This address is already updated");
        require(referrerTimeStamp[msg.sender] + referralCooldown < block.timestamp, "Referrer is on cooldown");

        whitelists[_address].status = true;
        whitelists[_address].referrer = msg.sender;
        counter++;
        referrerTimeStamp[msg.sender] = block.timestamp;
        emit ReferredWhitelisted(_address, msg.sender);
    }

    /**
     * @dev Allows the admin to update the referral cooldown time.
     * @param _cooldownTime The new referral cooldown time in seconds.
     */
    function updateReferralCooldown(uint _cooldownTime) public adminOnly {
        referralCooldown = _cooldownTime;
    }

    /**
     * @dev Returns the owner address.
     * @return The owner address.
     */
    function getOwner() public view returns (address) {
        return owner;
    }

    /**
     * @dev Returns the whitelist data for a given address.
     * @param _address The address to check.
     * @return The whitelist data for the given address.
     */
    function getWhitelist(address _address) public view returns(whitelistData memory) {
        return whitelists[_address];
    }

    /**
     * @dev Returns the total number of whitelisted users.
     * @return The total number of whitelisted users.
     */
    function getWhitelistCount() public view returns(uint) {
        return counter;
    }

    /**
     * @dev Returns the current referral cooldown time.
     * @return The current referral cooldown time in seconds.
     */
    function getCooldownTime() public view returns(uint) {
        return referralCooldown;
    }
}
