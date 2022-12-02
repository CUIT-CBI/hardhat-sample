// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "./Lock.sol";

contract FT is ERC20{
    address private Owner;
    

    constructor(string memory name, string memory symbol,uint256 _unlockTime) ERC20(name, symbol) 
    // Lock(_unlockTime) payable
    {
        Owner = msg.sender;
    }

    modifier onlyOwner(){
        require(Owner == msg.sender);
        _;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner{
        require(amount>0);
        _mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function ContinueTransfer() external {
        // withdraw();
    }
}
