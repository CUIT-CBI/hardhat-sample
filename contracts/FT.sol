// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract FT is ERC20, Pausable,Ownable {
    mapping(address => uint256)balance;
    uint256 _totalSupply;
    constructor(string memory name, string memory symbol) ERC20(name, symbol)  {
          
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner{
        balance[account]+=amount;
        _totalSupply +=amount;
    }
    function balanceOf(address account) public view virtual override returns (uint256) {
        return balance[account];
    }

    // // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
    require(balance[msg.sender] >=amount);
    balance[msg.sender]-=amount;
    _totalSupply-=amount;
    
    }
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    //TODO 加分项：实现transfer可以暂停的逻辑
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        require(from == msg.sender);
        balance[from]-=amount;
        balance[to] += amount;
        super._beforeTokenTransfer(from, to, amount);
    }
    function transfer(address from,address to,uint256 amount)external {
        _beforeTokenTransfer(from,to,amount);
    }
}
