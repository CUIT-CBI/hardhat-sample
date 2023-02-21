pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract FT is ERC20, Ownable, Pausable {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }
   
 // TODO 实现mint的权限控制，只有owner可以mint
    
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
        function burn(uint256 amount) external onlyOwner {
            _burn(msg.sender, amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(!paused(), "ERC20Pausable: token transfer while paused");
        super._beforeTokenTransfer(from, to, amount);
    }
    function pauseTransfer() public onlyOwner {
        _pause();
    }
    function unpauseTransfer() public onlyOwner {
        _unpause();
    }
}
