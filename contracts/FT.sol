// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FT is ERC20, Pausable, Ownable {
    address owner;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }
        
    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);

    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);

    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function setPause() public onlyOwner {
        _pause();
    }
    
    function setUnPause() public onlyOwner {
        _unpause();
    }
    //_beforeTokenTransfer:在任何代币转账前的 Hook,此处重写以判断转账是否暂停
    function _beforeTokenTransfer(address from, address to, uint256 amount) 
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
