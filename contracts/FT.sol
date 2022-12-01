// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract FT is ERC20 {
    // Set the owner address
    address private owner;

    // Set status of pause
    bool private pause;

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Unpaused(address account);
    
    /**
     * @dev Initializes owner and pause.
     */
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = _msgSender();
        pause = false;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
        require (_msgSender() == owner, "you are not the owner");
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(_msgSender(), amount);
    }
    
    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address to, uint256 amount) public override returns (bool) {
        require (!pause, "token transfer while paused");
        return super.transfer(to, amount);
    }

    /**
     * @dev Triggers stopped state.
     */
    function _pause() external {
        pause = true;
        emit Paused(_msgSender());

    }

    /**
     * @dev Returns to normal state.
     */
    function _unpause() internal {
        pause = false;
        emit Unpaused(_msgSender());
    }
}
