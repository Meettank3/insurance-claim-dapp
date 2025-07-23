// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract AddUser {
    
    address public owner;

    struct User {   
        int userId; 
        string name;
        int insuranceNo;
        address userAddress;
    }
        
    mapping (address => int) private userInsuranceCount; 
    mapping (address => int[]) private userInsuranceNumbers;

    int public userCount = 0;

    constructor() {
        owner = msg.sender;
    }

    mapping (address => User) public myUsers;

    modifier onlyOwner {
        require(owner == msg.sender, "Only Owner has access to this function");
        _;
    }

    event UserAdded(address indexed user, int userId, string name, int insuranceNo);
    event InsuranceAdded(address indexed user, int insuranceNo);

    function addUser(string memory _name, int _insuranceNo) public {
        require(myUsers[msg.sender].userId == 0, "User already exists");

        userCount += 1;
        myUsers[msg.sender] = User({
            userId: userCount,
            name: _name,
            insuranceNo: _insuranceNo,
            userAddress: msg.sender            
        });
        
        userInsuranceNumbers[msg.sender].push(_insuranceNo);
        userInsuranceCount[msg.sender]++;

        emit UserAdded(msg.sender, userCount, _name, _insuranceNo);
    }

    function getUser() public view returns (User memory) {        
        return myUsers[msg.sender];
    }

    function getInsuranceCount(address _user) public view onlyOwner returns (int) {
        return userInsuranceCount[_user];
    }

    function getInsuranceNumber(address _user) public view onlyOwner returns (int[] memory) {
        return userInsuranceNumbers[_user];
    }

    function myInsuranceNumbers() public view returns (int[] memory) {
        return userInsuranceNumbers[msg.sender];
    }

    function addNewInsurance(int _insuranceNo) public {
        require(myUsers[msg.sender].userId != 0, "User not registered");
        
        userInsuranceNumbers[msg.sender].push(_insuranceNo);
        userInsuranceCount[msg.sender]++;
        emit InsuranceAdded(msg.sender, _insuranceNo);
    }
}
