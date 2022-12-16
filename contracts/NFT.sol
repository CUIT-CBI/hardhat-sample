// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    mapping(uint256 => uint256) public indexOfTokenId;
    mapping(address => uint256) public ownerindexOfTokenId;
    mapping(uint256 => uint256) public tokenIdToIndex;

    uint256 internal totalSupplies;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    totalSupplies = 0;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(tokenId >= 0);
        super._mint(account, tokenId);

        totalSupplies++;
        ownerindexOfTokenId[account].push(tokenId);
        tokenIdToIndex[tokenId] = ownerindexOfTokenId[account].length;
        indexOfTokenId[totalSupplies] = tokenId;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(ownerOf(tokenId) == msg.sender);
        super._burn(tokenId);
        uint256[] storage tokens = ownerindexOfTokenId[msg.sender];
        //更新数组下标
        tokenIdToIndex[tokens[tokens.length - 1]] = tokenIdToIndex[tokenId];
        //更新tokenId数组
        uint256 temp = tokens[tokenIdToIndex[tokenId]];
        tokens[tokenIdToIndex[tokenId]] = tokens[tokens.length - 1];
        tokens[tokens.length - 1] = temp;
        tokens.pop();
        //删除
        delete tokenIdToIndex[tokenId];
        totalSupplies--;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalSupplies;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index < tokens.length);
        return ownerindexOfTokenId[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < this.totalSupply());
        return indexOfTokenId[index];
    }
}
