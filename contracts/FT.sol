// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract FT is ERC20,Pausable {
    address public owner;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner{
        //只有owner可以mint
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        //判断amount
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    
    //在转账之前检查是否被暂停
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        _requireNotPaused();
    }
    //在转账之前owner调用方法暂停交易
    function pause() external onlyOwner {
        _pause();
    }
}
