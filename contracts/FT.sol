// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20{

    address  owner = msg.sender;
    bool paused;

    constructor(string memory name, string memory symbol) 
        ERC20(name, symbol) {}

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(owner == msg.sender);
        _mint(account, amount);

    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function setPaused(bool _paused) public {
        paused = _paused;
    }
    
    function __transfer(address account, uint amount) public {
        require(!paused,"contract is paused");
        _transfer(msg.sender,account,amount);
   }

}
