@@ -4,18 +4,48 @@ pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address Administrator; //管理员账户
    bool _setTransfer;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        Administrator = msg.sender;
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {

        require(msg.sender == Administrator);
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
    }

    modifier setTransfer() {
        require(_setTransfer == true);
        _;
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address to, uint256 amount)
        public
        override
        setTransfer
        returns (bool)
    {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function setTransferFalse() external {
        require(msg.sender == Administrator);
        _setTransfer = false;
    }

    function setTransferTrue() external {
        require(msg.sender == Administrator);
        _setTransfer = true;
    }
}