// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address owner;//管理员
    bool open=true;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(account==owner, "Only owner can mint");
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
      require(balanceOf(msg.sender) >= amount,"your balance is not enough");
        _burn(msg.sender, amount);
    }

    modifier setOnOff(){
        require(open==true);
        _;
    }
    // TODO 加分项：实现transfer可以暂停的逻辑
   function transfer(address to,uint amount) public override setOnOff returns(bool){
       _transfer(msg.sender,to,amount);
       return true;
   }
   
   function setOn()external{
       require(msg.sender==owner,"you are not the owner");
       open=true;
   }
   function setOff()external{
       require(msg.sender==owner,"you are not the owner");
       open==false;
   }
}