// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    
    mapping(uint256 => uint256) public idToIndex;//tokenId to ownerTokenIndex
    mapping(address => mapping(uint256 => uint256)) public tokenList;//用户持有的tokenId列表
    uint256[] public tokens;//存储allToken
    mapping(uint256 => uint256) public  idToAllIndex;//tokenId to allTokenIndex
    
    function mint(address account, uint256 tokenId) external {
        // TODO
        _mint(account,tokenId);
        tokens.push(tokenId);
        idToAllIndex[tokenId] = tokens.length-1;
        uint256 length = balanceOf(account);
        idToIndex[tokenId] = length-1;
        tokenList[account][length-1] = tokenId;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "invalid sender");
        uint256 preIndex = idToAllIndex[tokenId];
        uint256 lastToken = tokens[tokens.length-1];
        _burn(tokenId);
        tokens.pop();
        tokens[preIndex] = lastToken;
        uint256 indexInList = idToIndex[tokenId];
        tokenList[owner][indexInList] = tokenList[owner][balanceOf(owner)];
        delete tokenList[owner][balanceOf(owner)];
        idToIndex[balanceOf(owner)] = idToIndex[tokenId];
        delete idToIndex[tokenId];
        delete idToAllIndex[tokenId];
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return tokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index < balanceOf(owner), "invalid index");
        return tokenList[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < tokens.length, "invalid index");
        return tokens[index];
    }
}
