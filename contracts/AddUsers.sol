    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.21;

    contract AddUser {
        
        address public owner; //address of the Owner
        
        struct User {   
            int User_Id; 
            string Name;
            uint Insurance_NO;
            address UserAddress;
        }
            
        mapping (address => uint) userInsuranceCount; // Count totall User's Insurance
        mapping (address => uint[]) userInsuranceNumbers; // Give Insurance NO

        int public userCount = 0;  // auto-increment user IDs

        constructor() {
            owner = msg.sender;
        }

        mapping (int => User) public myUsers; //making instance/Object of the User in Mapping 

        modifier OnlyOwner{
            require(owner == msg.sender, "Only Owner Has a Access to This ");
            _;
        }

        // Add a new user
        function addUser(string memory _name, uint _insurance_no) public {
            userCount += 1;  // increment user count
            
            myUsers[userCount] = User({
                User_Id: userCount,
                Name: _name,
                Insurance_NO: _insurance_no,
                UserAddress: msg.sender            
            });
            
            userInsuranceNumbers[msg.sender].push(_insurance_no); // Add Ins Numb in user Address
            userInsuranceCount[msg.sender]++; // Increment by 1

        }

        // Get user by user ID
        function getUser(int _user_Id) public view returns (User memory) {        
            return myUsers[_user_Id];
        }

        function getInsuranceCount(address _user) public view OnlyOwner returns (uint) {
            return userInsuranceCount[_user];
        }

        function getInsuranceNumber(address _user) public view  OnlyOwner returns (uint[] memory) {
            return userInsuranceNumbers[_user];
        }

        function addNewInsurance(uint _insurNo) public  {
            userInsuranceNumbers[msg.sender].push(_insurNo);
            userInsuranceCount[msg.sender]++;
        }
    }