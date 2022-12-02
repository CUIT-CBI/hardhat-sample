// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address public owner;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender==owner,"onlyOwner");
        _;
    }
    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        _mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender,amount);
    }
    function setPause()public onlyOwner{
        _pause();
    }
    function setUnPaused()public onlyOwner{
        _unpause();
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
        function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require(!paused(), "ERC20Pausable: token transfer while paused");
    }
}
