// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Lock.sol";

 contract FT is ERC20 {
     string public _name;
     string public _symbol;
    //  uint8 public override decimals;

    bool isPaused = false;

    address owner = msg.sender;
     
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the contract Owner!");
    _;}

    constructor(string memory name, string memory symbol) 
        ERC20(name, symbol) {
        _name = name;
        _symbol = symbol;
        
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(account != address(0), "ERC20: mint to the zero address!");
        require(account == owner, "You are not the contract owner!");
        _mint(account,amount);
        
    }

    // TODO 用户只能燃烧自己的token
    function burn(address account , uint256 amount) external {
       require(account == msg.sender,"you are not the owner!");
        _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function pause() public onlyOwner{
        
        require(isPaused == false, "Now it's already pausing time!");
        isPaused = true;
    }
    function Unpause() public onlyOwner {
        
        require(isPaused == true, "It's not pausing now!");
        isPaused = false;
    }
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        require(isPaused == false, "It's pausing time!");
        super.transfer(recipient, amount);
        return true;
    }

 
}
