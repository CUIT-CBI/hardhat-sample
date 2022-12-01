// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pauble";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FT is ERC20 {


    //自己新加的owner
    //1.定义一个不能被更改的owner
   address public immutable owner;
    //2. address 到 持仓数量 的持仓量映射
    mapping(address => uint) private balance;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner=msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
         require( account == owner,"sorry, only owner can mint");
         _mint(account, amount); //调用ERC20里面的_mint方法，
        


    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        
         _burn(msg.sender,amount); //调用ERC20里面的_burn方法，

       

    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    // function transfer( address from , address to,uint256 amount) external whenNotPaused {
        
    // }
  function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(!paused(), "contract is paused");
        super._beforeTokenTransfer(from, to, amount);
    }

    function setPause() public onlyOwner() {
        _pause();
    }

    function setUnPause() public onlyOwner() {
        _unpause();
    }
  






    

}
