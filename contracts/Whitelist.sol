// SPDX-License-Identifier: MIT
// < x - + / - x + Test Contract + x - \ + - x >
pragma solidity 0.8.20;

contract Whitelist{
    address owner;

    address admin;

    struct whitelistData{
        bool status;
        address referrer;
    }

    mapping(address => whitelistData) whitelists;

    uint counter;

    uint referralCooldown = 30 minutes;
    mapping(address => uint) referrerTimeStamp;

    constructor(){
        owner=msg.sender;
    }

    modifier ownerOnly(){
        require(msg.sender==owner,"Only Owner of this contract can perform this action!");
        _;
    }

    modifier adminOnly(){
        require(msg.sender==admin,"Only admin of this contract can perform this action!");
        _;
    }

    modifier whitelistedOnly(){
        require(whitelists[msg.sender].status==true,"Only whitelisted users can perform this action!");
        _;
    }

    function updateAdmin(address _address) public ownerOnly{
        require(msg.sender!=admin,"admin address already updated");
        admin = _address;
    }

    function getAdminAddress() public view returns(address){
        return admin;
    }

    event DirectlyWhitelisted(address indexed user, bool newStatus);

    function directWhitelist(address _address,bool _status) public adminOnly{
        require(whitelists[_address].status!=_status,"Whitelist Status is already updated");
        whitelists[_address].status = _status;
        if(_status==true){
            counter++;
        }else{
            counter--;
        }

        emit DirectlyWhitelisted(_address, _status);
    }

    event ReferredWhitelisted(address indexed user, address indexed referrer);

    function referWhitelist(address _address) public whitelistedOnly {
        require(whitelists[_address].status != true, "This address is already updated");
        require(referrerTimeStamp[msg.sender] + referralCooldown < block.timestamp, "Referrer is on cooldown");

        whitelists[_address].status = true;
        whitelists[_address].referrer = msg.sender;
        counter++;
        referrerTimeStamp[msg.sender] = block.timestamp;
        emit ReferredWhitelisted(_address, msg.sender);
    }

    function updateReferralCooldown(uint _cooldownTime) public adminOnly{
        referralCooldown = _cooldownTime;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getWhitelist(address _address) public view returns(whitelistData memory){
        return whitelists[_address];
    }

    function getWhitelistCount() public view returns(uint){
        return counter;
    }

    function getCooldownTime() public view returns(uint){
        return referralCooldown;
    }
    
}