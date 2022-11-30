// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FT is ERC20,Pausable,Ownable {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner {
        ERC20._mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        ERC20._burn(_msgSender(),amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address to, uint256 amount) public virtual override whenNotPaused returns (bool) {
        return super.transfer(to,amount);
    }

    function pause() public onlyOwner{
        _pause();
    }


    function unpause() public onlyOwner{
        _unpause();
    }
}
