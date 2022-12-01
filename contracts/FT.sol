// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address owner;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(msg.sender == owner,"");
        _mint(account, amount);

    }

    // TODO
    function burn(uint256 amount) external {
        require(allowance(owner, msg.sender)==amount,"");
        _burn(msg.sender, amount);

    }

    // TODO 加分项：实现transfer可以暂停的逻辑
}
