// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract FT is ERC20, Pausable{
    address public owner;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) Pausable(){
        owner = msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(msg.sender == owner,"only owner can mint");
        _mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    // 只有 owner 可以暂停交易
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(!paused(), "ERC20Pausable: token transfer while paused");
        super._beforeTokenTransfer(from, to, amount);
    }

    function setPause() public {
        require(msg.sender == owner);
        _pause();
    }

    function setUnpause() public {
        require(msg.sender == owner);
        _unpause();
    }
}
