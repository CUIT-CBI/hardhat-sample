// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Uncomment this line to use console.log
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CBI is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }
}
