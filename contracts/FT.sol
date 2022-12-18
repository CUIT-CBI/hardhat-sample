// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
contract FT is ERC20,Pausable {
    //默认internal修饰owner
    address owner;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    owner=msg.sender;
    }
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
}

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
       _burn(msg.sender,amount);
    }
     
    // TODO 加分项：实现transfer可以暂停的逻辑
    //function _beforeTokenTransfer是ecr20合约中的抽象函数，但为何要重写后再次调用呢？
    // function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override whenNotPaused {
    //     super._beforeTokenTransfer(from, to, amount);
    // }
  function transfer(address to, uint256 amount) public override whenNotPaused returns (bool) {
      //先变成true
    //   function _pause() internal virtual whenNotPaused {
    //     _paused = true;
    //     emit Paused(_msgSender());
    // }
    //超过一万个币就暂停
    if(amount >= 10**22){
      _pause();
    }
    // function paused() public view virtual returns (bool) {
    //     return _paused;
    // }
        return super.transfer(to, amount);
     }
     //直接终止
     function pause() external onlyOwner{
       _pause();
     }
     //恢复转账
     function unpause() external onlyOwner{
       _unpause();
     }
}