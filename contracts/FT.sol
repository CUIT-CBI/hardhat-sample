// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
      
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require( account == msg.sender,"you are not the owner");
        require(amount > 0);
        super._mint(account,amount);

    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        require(amount > 0);
        super._burn(msg.sender,amount);

    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    bool op=false;
    address owner;
    function transfer(address to,uint256 amount) public override returns(bool){
        require(op);
        require(owner == msg.sender);
        super._transfer(owner,to,amount);
        return true;
    }

    function paused() external returns(bool){
        require(msg.sender == owner,"you are not the owner");
        op = false;
        return op;
    }

    function unPaused() external returns(bool){
        require(msg.sender == owner,"you are not the owner");
        op = true;
        return op;
    }
}

