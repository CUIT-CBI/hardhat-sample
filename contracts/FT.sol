// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FT is ERC20,Pausable{
    address public owner;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }
    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner{
        super._mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external onlyOwner{
        super._burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    // function pause() public onlyOwner {
    //     _pause();
    // }

    // function unpause() public onlyOwner {
    //     _unpause();
    // }

    // function _beforeTokenTransfer(address from, address to, uint256 amount)
    //     internal
    //     whenNotPaused
    //     override
    // {
    //     require(from == msg.sender);
    //     //balance[from]-=amount;
    //     //balance[to] += amount;
    //     super._beforeTokenTransfer(from, to, amount);
    // }
    // function transfer(address from,address to,uint256 amount)external {
    //     _beforeTokenTransfer(from,to,amount);
    // }
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
