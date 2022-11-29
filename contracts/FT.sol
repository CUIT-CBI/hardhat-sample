// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address Creator;
    bool TransferState;
    constructor(string memory name, string memory symbol) ERC20(name,symbol) {
        Creator = msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(msg.sender == Creator);
        _mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender,amount);
    }
    
    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address sender,address recipient,uint256 amount) external returns(bool){
        require(TransferState == true);
        _transfer(sender, recipient, amount);
    }
    function transferState(bool _state) external returns(bool){
        require(msg.sender == Creator);
        if(_state == true){
        TransferState = true;
        }else{
            TransferState = false;
        }
    }
}

