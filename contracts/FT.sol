// SPDX-License-Identifier: UNLICENSED
// 指定合约的许可证，这里指的是没有许可证
pragma solidity ^0.8.0;

// 导入 ERC20 合约，用于代币操作
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// 导入 Pausable 合约，用于实现暂停功能
import "@openzeppelin/contracts/security/Pausable.sol";

// 导入 Ownable 合约，用于实现权限控制
import "@openzeppelin/contracts/access/Ownable.sol";

// 定义一个 FT 合约，继承 ERC20、Pausable、Ownable 合约
contract FT is ERC20, Pausable, Ownable {

    // 构造函数，定义代币的名称和符号
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    // TODO 实现 mint 的权限控制，只有 owner 可以 mint
    function mint(address account, uint256 amount) external onlyOwner {
        // mint 代币到指定地址
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的 token
    function burn(uint256 amount) external {
        // 燃烧指定数量的代币，必须是调用者的代币才能燃烧
        _burn(msg.sender, amount);
    }
    
    // TODO 加分项：实现 transfer 可以暂停的逻辑
    // 在转账之前，检查合约是否已经被暂停，如果暂停，则不允许转账
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    // 暂停合约的转账功能，只有 owner 可以调用
    function setPause() public onlyOwner() {
        _pause();
    }

    // 恢复合约的转账功能，只有 owner 可以调用
    function setUnPause() public onlyOwner() {
        _unpause();
    }
}
