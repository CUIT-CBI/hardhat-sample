// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(account != address(0), "ERC20: mint to the zero address");
        require(account == msg.sender,"only owner can mint");
        require(amount > 0,"amount");
        super._mint(account,amount);

    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        require(amount > 0);
        super._mint(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
}
