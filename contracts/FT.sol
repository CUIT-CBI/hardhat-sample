// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    address private owner;
    bool public lock;

constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    owner = msg.sender;
    lock = false;
    }
    modifier isLock(){
      require(!lock,"is lock");
      _;
    }


    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {
      require(msg.sender == owner);
      _mint(account,amount);
    }
    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
     require(balanceOf[msg.sender] >= amount,"not enough");
     _burn(msg.sender,amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function transfer(address _to,uint amount) public virtual override isLock returns (bool){
      require(balanceOf[msg.sender] >= amount,"not enough");
      _transfer(msg.sender, _to, amount);
      return ture;
      }
    function transferFrom(address _from,address _to,uint256 _amount) public virtual override isLock returns (bool){
  address _spender = _msgSender();
  _spendAllowance(_from,_spender, _amount);
  _transfer(_from,_spender,_amount);
  return true;
}
function changeLock() external returns(bool){
  require(msg.sender == owner,"is not owner");
  lock = !lock;
  return true;
}
}   