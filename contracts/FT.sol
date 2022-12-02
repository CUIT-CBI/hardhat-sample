// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {

    address public owner;
    bool private open;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(account != address(0), "not commit zero address!"  );
        require(account == owner);
        super._mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
       _burn(owner, amount);
    }

    modifier pause() {
        require(open == true);
        _;
    }
    // TODO 加分项：实现transfer可以暂停的逻辑
    function suspendTransfer(address from, address to, uint256 amount) public pause returns(bool) {
        require(from == owner);
        require(to != address(0));
        open == false;
        _transfer(from, to, amount);
        return true;
    }
    
}
