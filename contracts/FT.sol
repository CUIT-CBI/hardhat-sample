// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract FT is ERC20,Pausable{
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }
    
    modifier OnlyOwner{
        require (msg.sender == owner,"you don't have permission");
        _;
    }
    
    function mint(address account, uint256 amount) external OnlyOwner{
        super._mint(account, amount);
    }

    function burn(uint256 amount) external {
        super._burn(msg.sender,amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        require(!paused(), "contract is paused");
        super._beforeTokenTransfer(from, to, amount);
    }
    
    function Pause() external onlyOwner{
        _pause();
    }
    
    function Unpause() external onlyOwner{
        _burn(msg.sender, amount);
    }
}
