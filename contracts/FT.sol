// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract FT is ERC20 ,Pausable{

    address  owner = msg.sender;
    constructor(string memory name, string memory symbol) 
        ERC20(name, symbol) {}

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(owner == msg.sender,'you are not the owner!');
        _mint(account, amount);

    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        require(owner == msg.sender,'you are not the owner!');
        _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
  function __transfer(address account, uint amount) public whenNotPaused {
        _transfer(msg.sender,account,amount);
   }

}
