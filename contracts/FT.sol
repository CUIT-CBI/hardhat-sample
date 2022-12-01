// SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address owner = msg.sender;
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {

        require(account == owner, "ERC20:only owner can mint");
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);

    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    uint256 Stop = 0;
    modifier stop {
        require(Stop==1);
        _;
    }
    modifier onlyAuthorized {
        require(msg.sender == owner);
        _;
    }
    //停止转账
    function stopTransFer() public onlyAuthorized {
        Stop = 1;
    }
    //继续转账
    function resumeTransFer() public onlyAuthorized {
        Stop = 0;
    }

    function transfer(address to, uint256 amount) public virtual override stop returns (bool){
        address _owner;
        _owner = msg.sender;
        _transfer(_owner, to, amount);
        return true;
    }
}
