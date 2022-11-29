// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address public immutable owner;
    bool open = false;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner,"you are not owner!");
        _;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner{
        ERC20._mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        ERC20._burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address to, uint256 amount) public override returns (bool){
        require(open,"close!");
        return ERC20.transfer(to,amount);
    }
    function unlock() public onlyOwner{
        open = true;
    }
    function lock() public onlyOwner{
        open = false;
    }
}
