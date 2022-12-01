// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address owner;
    bool open=false;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner=msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(account==owner, "Only owner can mint");
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        require(amount<= msg.sender.balance,"your balance is not enough");
        _burn(msg.sender, amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address to, uint256 amount) public override returns (bool) {
        require(open, "sorry,the transfer is closed");
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }
    function lock()external returns(bool){
        require(msg.sender == owner, "you are not the owner");
        open=false;
        return open;
    }
    function unlock()external returns(bool){
        require(msg.sender == owner, "you are not the owner");
        open=true;
        return open;
    }
}
