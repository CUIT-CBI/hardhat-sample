// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address _owner = msg.sender; 
    constructor(string memory name, string memory symbol) ERC20(name, symbol) { 
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(account != address(0),"mint to zero address");
        require(account == msg.sender,"mint can't be created");
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
    bool isStopped = false;
    modifier stopped {
        require(!isStopped);
        _;
    }
    modifier onlyAuthorized {
        require(msg.sender == _owner);
        _;
    }

    function stopTransFer() public onlyAuthorized {
        isStopped = true;
    }

    function resumeTransFer() public onlyAuthorized {
        isStopped = false;
    }

    function transfer(address to, uint256 amount) public virtual override stopped returns (bool){
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _amount) public virtual override stopped returns (bool){
    address _spender = _msgSender();
    _spendAllowance(_from, _spender, _amount);
    _transfer(_from, _to, _amount);
    return true;
    }
}
