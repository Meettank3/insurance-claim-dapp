// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AddUser} from "./AddUsers.sol";

contract UserInsuranceClaim is AddUser {

    struct Claim {
        uint claimId;
        address user;
        uint insuranceNo;
        string reason;
        uint amount;
        string status; // "Pending", "Approved", "Rejected"
    }

    uint public claimCount = 0;
    mapping(uint => Claim) public claims;
    mapping(address => uint[]) public userClaims;

    event ClaimRequested(uint indexed claimId, address indexed user, uint insuranceNo, uint amount, string reason);
    event ClaimUpdated(uint indexed claimId, string status);

    function requestClaim(string memory _reason, uint _insuranceNo, uint _amount) public {
        require(myUsers[msg.sender].userId != 0, "User not registered");

        claimCount += 1;

        claims[claimCount] = Claim({
            claimId: claimCount,
            user: msg.sender,
            insuranceNo: _insuranceNo,
            reason: _reason,
            amount: _amount,
            status: "Pending"
        });

        userClaims[msg.sender].push(claimCount);

        emit ClaimRequested(claimCount, msg.sender, _insuranceNo, _amount, _reason);
    }

    function updateClaimStatus(uint _claimId, string memory _status) public onlyOwner {
        require(_claimId > 0 && _claimId <= claimCount, "Invalid claim ID");
        require(
            keccak256(bytes(_status)) == keccak256(bytes("Approved")) ||
            keccak256(bytes(_status)) == keccak256(bytes("Rejected")),
            "Invalid status"
        );

        claims[_claimId].status = _status;

        emit ClaimUpdated(_claimId, _status);
    }

    function getMyClaims() public view returns (uint[] memory) {
        return userClaims[msg.sender];
    }

    function getClaimDetails(uint _claimId) public view returns (Claim memory) {
        return claims[_claimId];
    }
}
