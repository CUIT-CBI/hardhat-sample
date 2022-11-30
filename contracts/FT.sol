// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FT is ERC20, Ownable, Pausable{
    address public owner;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    // 修饰符权限控制
    function mint(address account, uint256 amount) external onlyOnwer() {
        // 调用erc20方法
        _mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        
        // 燃烧自己的token，账户为调用者
        _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑

    function pause() public onlyOnwer(){
        // 改变变量状态
        _pause();
    }

    function unpause() public onlyOnwer(){
        _unpause();
    }

    function _beforeTransfer(address from,address to,uint256 amount)
    internal
    whenNotPaused
    override{
        super._beforeTransfer(from,to,amount);
    }
}
