// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address owner;
    bool STOP = false;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
         owner = msg.sender;
         
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(msg.sender == owner);
        _mint(account,amount);

    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address to, uint256 amount) public override returns(bool) {
        require(STOP == false);
        address owners = _msgSender();
        _transfer(owners, to, amount);
        return true;
    }
}
