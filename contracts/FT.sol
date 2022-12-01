// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    
    //管理员地址
    address private admin;
    //存储每个账户的冷却时间
    mapping(address => uint256) cooldownTime;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        admin = msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(admin == msg.sender, "Only the administrator address can be called!");
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        require(amount <= msg.sender.balance, "Your balance is insufficient");
        _burn(msg.sender, amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(cooldownTime[msg.sender] < block.timestamp, "Your account is in a cooling-off period");
        require(msg.sender.balance > amount, "Your account balance is insufficient");
        _transfer(msg.sender, to, amount);
        return true;
    }

    //设置调用者账户的冷却时间（秒）
    function setCooldownTime(uint256 second) public returns(bool){
        uint256 timeStamp = second + block.timestamp;
        cooldownTime[msg.sender] = timeStamp;
        return true;
    }
}
