// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    uint256 counter = 0;
    uint256 ind = 0;
    mapping(address => uint256[]) private _user;
     //mapping(uint256 => uint256) private _list;
    uint256[] private _list;
    mapping(uint256 => uint256) private _reverList;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    
    function mint(address account, uint256 tokenId) external {
        // TODO
        _mint(account, tokenId);
        counter++;  
        _user[account].push(tokenId);
        _list.push(tokenId);
        _reverList[tokenId] = ind;
        ind++;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(_ownerOf(tokenId) == msg.sender, "NOT your token!");
        _burn(tokenId);
        uint256 temp = _reverList[tokenId];
        if(temp == _list.length-1){
            _list.pop();
            _user[msg.sender].pop();
        }else{
            _list[temp] = _list[_list.length-1];
            _user[msg.sender][temp] = _user[msg.sender][_user[msg.sender].length-1];
            _list.pop();
            _user[msg.sender].pop();
        }
        counter--;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return counter;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(owner != address(0), "NULL ADDRESS!");
        require(index <= _list.length - 1, " index OUTOFRANGE!");
        return _user[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index <= _list.length - 1, " index OUTOFRANGE!");
        return _list[index];
    }
}
