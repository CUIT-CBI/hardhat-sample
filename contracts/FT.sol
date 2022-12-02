// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FT is ERC20 {
    bool private _paused;
    // set immutable maybe is the best choice
    address  immutable creator;
    function getPaused()public view returns(bool){
        return _paused;
    }
    function getCreator()public view returns(address){
        return creator;
    }
    function unpaused()external isCreator{
        require(_paused,"the _paused cant need to update");
        _paused=false;
    }
    function paused()external isCreator{
              require(!_paused,"the _paused cant need to update");
              _paused=true;
    }
    constructor(string memory name, string memory symbol) ERC20(name, symbol) payable{
        creator=msg.sender;
    }
    //inspect  whether authority is enough  
    modifier isCreator(){
        require(msg.sender==creator,"cant have power to update paused variable");
        _;
    }
    modifier hasToken(address src){
        //need judge _allowance???
        require(balanceOf(src)>0);
        _;
    }
    // TODO 实现mint的权限控制，只有owner可以mint(owner????????)
    function mint(address account, uint256 amount) external  hasToken(account){
              super._mint(account,amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {
       _burn(msg.sender, amount);
    }
     error pauseTransfer(string  explain );
    // TODO 加分项：实现transfer可以暂停的逻辑
       function _beforeTokenTransfer(
        address ,
        address ,
        uint256 
    ) internal override {
        _judge();
    }
    function _judge()internal view {
        if(_paused){
                revert pauseTransfer("parse transfer");
        }
    }

}
contract testFT{
    FT public testContract;
    constructor()payable{
         testContract=new FT("xiyang","xiyang");
    }
    receive()external payable{

    }
    function scanCreator()external view returns(address){
       return testContract.getCreator();
    }
    function scanPaused()external view returns(bool){
      return  testContract.getPaused();
    }
    error  testError(string errorInfo,bytes payload);
    function _otherUpdatePaused()internal returns(string memory){
           bool  preResult=testContract.getPaused();
           //why cant use calldata
          bytes memory unpausedPayload=abi.encode(keccak256("unpaused()"));
            bytes memory pausedPayload=abi.encode(keccak256("paused()"));
            if(preResult){
              (bool result,bytes memory payload)=msg.sender.call(unpausedPayload);
              if(result){
                 revert testError("otherUpdatePaused test failed",payload);
              }
           }else{
               (bool result,bytes memory payload)= msg.sender.call(pausedPayload);
                   if(result){
                 revert testError("otherUpdatePaused test failed",payload);
              }
           }
    }
    function testPaused()external returns(string memory){
       for(uint256 index=0;index<2;index++){
           _testOwnerPaused();
        //    _otherUpdatePaused();
       }
       return "paused variable and function test pass";
    }
    function _testOwnerPaused()internal{
           bool  preResult=testContract.getPaused();
           if(preResult){
               testContract.unpaused();
           }else{
               testContract.paused();
           }
    }
    function getAddressZero()external returns(address){
        return address(testContract);
    }
    function testMintFunction(uint256 tokenId)external returns(string memory){
            testContract.mint(address(testContract),tokenId);
            require(tokenId==testContract.balanceOf(address(testContract)),"mint testing function err");
            return "mint function test pass";
        
    }
}
