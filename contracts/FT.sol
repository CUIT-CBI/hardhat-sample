// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
    require(account==msg.sender,"only onwer can mint");
       require(account!=address(0));
       require(amount>0);
       super._mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
    require(amount>0);
    super._mint(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    //以下是erc20中transfer函数，不会用transfer实现暂停的逻辑
    function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
    // msg.sender余额中减去额度，_to余额加上相应额度
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    //触发Transfer事件
    emit Transfer(msg.sender, _to, _value);
    return true;
  }
}
