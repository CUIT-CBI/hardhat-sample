// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract FT is ERC20,Pausable {

    address payable public owner;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = payable(msg.sender);
    }
    
    modifier onlyOwner() {
    require(msg.sender == owner, "You are not the owner");
    _;
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
    
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
        ) internal override {
        require(!paused(),"token transfer was paused");
        _transfer(from,to, amount);
    }
}
