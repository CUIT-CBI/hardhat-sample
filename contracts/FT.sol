// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {

    bool private _paused;

    address contractOwner;

    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        return(contractOwner == msg.sender);
         _mint(to, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function pause() public {
        return(contractOwner == msg.sender);
        _paused = true;
    }

    function unpause() public  {
        return(contractOwner == msg.sender);
        _paused = false;
    }

    function transfer(to, amount) external {
        _beforeTokenTransfer(from, to, amount);
        _transfer(msg.sender, to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal whenNotPaused {}
    
}
