// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract AddUser {
    struct User {   
        int User_Id; 
        string Name;
        uint Insurance_NO;
        address UserAddress;
    }
    
    mapping (int => User) public myUsers;
    int public userCount = 0;  // auto-increment user IDs

    // Add a new user
    function addUser(string memory _name, uint _insurance_no) public {
        userCount += 1;  // increment user count
        
        myUsers[userCount] = User({
            User_Id: userCount,
            Name: _name,
            Insurance_NO: _insurance_no,
            UserAddress: msg.sender
        });
    }

    // Get user by user ID
    function getUser(int _user_Id) public view returns (User memory) {        
        return myUsers[_user_Id];
    }
}