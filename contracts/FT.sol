// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require(account == _msgSender(), "Only owner can mint!");

        _mint(account, amount);

    }

    // TODO 用户只能燃烧自己的token
    
    function burn(uint256 amount) external {
        address account = _msgSender();
        _burn(account, amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    //这个不会，CSDN上搜的

  event Pause();
  event Unpause();
 
  // 暂停状态，false表示未暂停，true表示暂停
  bool public paused = false;
 
  // 未暂停状态
  modifier whenNotPaused() {
    require(!paused);
    _;
  }
 
  // 暂停状态
  modifier whenPaused() {
    require(paused);
    _;
  }
 
  // 将合约状态改为暂停状态
  function pause() whenNotPaused public {
    paused = true;
    emit Pause();
  }
 
  function unpause() whenPaused public {
    paused = false;
    emit Unpause();
  }

}

