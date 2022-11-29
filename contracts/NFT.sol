// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    uint256 counter = 0;
    uint256 ind = 1;
    mapping(address => mapping(uint256 => uint256)) private _user;
    mapping(uint256 => uint256) private _list;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    
    function mint(address account, uint256 tokenId) external {
        // TODO
       _mint(account, tokenId);
       counter++;  
       _user[account][ind] = tokenId;
       _list[ind] = tokenId;
       ind++;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(_ownerOf(tokenId) == msg.sender, "NOT your token!");
        _burn(tokenId);
        counter--;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return counter;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(owner != address(0), "NULL ADDRESS!");
        require(_user[owner][index] != 0, " index OUTOFRANGE!");
        return _user[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(_list[index] != 0, " index OUTOFRANGE!");
        return _list[index];
    }
}
