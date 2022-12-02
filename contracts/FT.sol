// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract CYYFT is ERC20, Ownable, Pausible{
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    //TODO 实现mint的权限控制
    function mint(address account, uint256 amount) external onlyOwner() {
        _mint(account, amount);
    }

    //TODO shixian用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(!paused(), "contract is paused");
        super._beforeTokenTransfer(from, to, amount);
    }

    function setPause() public onlyOwner() {
        _pause();
    }

    function setUnPause() public onlyOwner() {
        _unpause();
    }
}
