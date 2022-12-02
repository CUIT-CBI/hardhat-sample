// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(msg.sender == account);
        require(account !=address(0),'ERC20: mint to the zero address!');
       _totalSupply = _totalSupply+amount;
        _balances[account] = _balances[account]+amount;
  
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        require(msg.sender != address(0), 'ERC20: burn from the zero address');

        _balances[msg.sender] = _balances[msg.sender]-amount;
       _totalSupply= _totalSupply-amount;
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
}
