// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Banker {
    mapping (address=>uint256) public balanceOf;

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Banker: insufficient balance.");
        (bool result,) = msg.sender.call{value: amount}("");
        require(result, "Failed to withdraw Ether");
        unchecked {
            balanceOf[msg.sender] -= amount;
        }
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}