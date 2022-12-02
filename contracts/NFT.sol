// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    // mapping 
    uint256 public totalBalance = 0;
    mapping(address => uint256[])  tokenIdTOOrders; //通过地址和tokenid的索引查询tokenid
    mapping(uint256 => uint256) indexTotokenId;//通过全局索引查寻tokenid
    mapping(uint256 => uint256) idToindex;//通过tokenid查询全局索引
    mapping(uint256 => uint256) idTotokenIdindex;//通过全局索引查询tokenid索引
    // uint256[] orders;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        _mint(account,tokenId);
        tokenIdTOOrders[account].push(tokenId);
        indexTotokenId[totalBalance] = tokenId;
        idToindex[tokenId] = totalBalance;
        idTotokenIdindex[tokenId] = tokenIdTOOrders[account].length-1;
        totalBalance++;
    }

    function burn(uint256 tokenId) external{
        // TODO 用户只能燃烧自己的NFT
        require(_ownerOf(tokenId) == msg.sender);
        address owner = ownerOf(tokenId);
        uint256 index = idToindex[tokenId];
        delete tokenIdTOOrders[owner][index];
        delete indexTotokenId[index];
        delete idToindex[tokenId];
        delete idTotokenIdindex[tokenId];
        totalBalance--;
        _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalBalance;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        uint256 _tokenId = tokenIdTOOrders[owner][index];
        return _tokenId;
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        uint256 _tokenId = indexTotokenId[index];
        return _tokenId;
    }
}
