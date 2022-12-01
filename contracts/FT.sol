// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "./Lock.sol";

contract FT is ERC20,Pausable, Ownable{
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        // _owner = msg.sender;
        // _lock = LockAddress;
    }
    // address _owner;
    // address public _lock;
    // modifier onlyOwner(){
    //     require(_owner == msg.sender);
    //     _;
    // }
    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner{
        _mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender,amount);
    }
    
    // TODO 加分项：实现transfer可以暂停的逻辑
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal whenNotPaused override{
        require(!paused());
        super._beforeTokenTransfer(from, to, amount);
    }

    function pause() public onlyOwner {
        _pause();
    }
    function unpause() public onlyOwner {
        _unpause();
    }
}
