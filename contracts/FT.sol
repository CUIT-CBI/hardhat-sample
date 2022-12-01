// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Lock.sol";
contract FT is ERC20 ,Lock {
    uint256 toBufferTime;
    address private  owners = msg.sender;
    constructor(string memory name, string memory symbol,uint256 time) ERC20(name, symbol) Lock(time){
        toBufferTime = time;
    }
    mapping(uint256 => bool) private istransfer;
    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(msg.sender == owners,'not owner');
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
    
    // TODO 加分项：实现transfer可以暂停的逻辑
    function stoptransfer() public {
        require(msg.sender == owners, 'your not owners');
        istransfer[toBufferTime] = false;
    }
    function continueTransfer() public {
        require(msg.sender == owners, 'your not owners');
        istransfer[toBufferTime] = false;
    }
    function beferTokentransfer(address from ,address to,uint256 amount) public{
        if (istransfer[toBufferTime] == false){
            Lock.withdraw();
        }else {
            _afterTokenTransfer(from, to, amount);
        }
    }
}
