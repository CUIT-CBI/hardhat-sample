// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Lock.sol";

contract FT is ERC20 {

    uint public unlockTime;
    address payable public owner;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = payable(msg.sender);
        _mint(msg.sender, 1000000000000000000000000);
    }
    
    modifier onlyOwner() {
    require(msg.sender == owner, "You are not the owner");
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) onlyOwner external {
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount)  external {
        _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function pausedTransfer(uint256 _unlockTime) onlyOwner external {
        unlockTime = _unlockTime;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
       require(block.timestamp >= unlockTime,"the transfer still paused");
       require(msg.sender == owner,"you are not the owner");
       _transfer(msg.sender, recipient, amount);
       return true;
    }
}
