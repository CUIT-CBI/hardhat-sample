// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
contract FT is ERC20,Pausable {
    address owner;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
         owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner,"Not Owner");
        _;
    }
    // TODO 实现mint的权限控制：即只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner{
        _mint(account,amount);
    }
    // TODO 用户只燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender,amount);
    }
    // TODO 加分项
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
    function pause()  external onlyOwner{
        _pause();
    }
    function unpause()  external onlyOwner{
        _unpause();
    } 
}
