// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {


    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }


    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {

    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {

    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    //hook
    //Hooks are simply functions that are called before or after some action takes place
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal virtual override
    {
        super._beforeTokenTransfer(from, to, amount);
    }
   
    //新增
    function pause() external onlyOwner {
        _pause();
    }
    
    //新增
    function unpause() external onlyOwner {
        _unpause();
    }
   
}
