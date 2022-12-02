// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address owner;
    bool isStop;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(msg.sender==owner,"Only owner can mint.");
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
         require(allowance(owner, msg.sender)==amount,"Users can only burn their own tokens");
         _burn(msg.sender, amount);

    }

    // TODO 加分项：实现transfer可以暂停的逻辑

    function setIStop(bool isstop) public {
        require(msg.sender==owner);
        isStop = isstop;
    } 
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(isStop==false);
        _transfer(owner, to, amount);
        return true;
    }
   

}
