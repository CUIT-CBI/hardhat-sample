import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {

    address owner = msg.sender;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
      require(account == msg.sender, "NOT owner!");
      _mint(account, amount);

    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {

      _burn(msg.sender, amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    bool temp = true;

    function stopTransfer()public returns (bool){
        require(msg.sender == owner, "you can NOT do this opreation!");
        temp = false;
        return true;
    }
    function countinueTransfer()public returns (bool ){
        require(msg.sender == owner, "you can NOT do this opreation!");
        temp = true;
        return true;
    }
    function transfer(address to, uint256 amount) public virtual override returns (bool){
        require(temp == true, "transfer opreation can NOT work!");
            address runner = _msgSender();
            _transfer(runner, to, amount);
            return true;

    }
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        require(temp == true, "transfer opreation can NOT work!");
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

}
