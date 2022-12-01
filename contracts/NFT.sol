// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    uint256 internal totalSupplies;
    mapping(uint256 => uint256) public indexToTokenId;
    mapping(address => uint256[]) public ownerIndexToTokenId;
    mapping(uint256 => uint256) public tokenIdToIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        totalSupplies = 0;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        super._mint(account, tokenId);
        // token总供应量增加
        totalSupplies++;
        ownerIndexToTokenId[account].push(tokenId);
        tokenIdToIndex[tokenId] = ownerIndexToTokenId[account].length - 1;
        indexToTokenId[totalSupplies] = tokenId;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        super._burn(tokenId);
        uint256[] storage tokens = ownerIndexToTokenId[msg.sender];
        tokenIdToIndex[tokens[tokens.length - 1]] = tokenIdToIndex[tokenId];
        uint256 temp = tokens[tokenIdToIndex[tokenId]];
        tokens[tokenIdToIndex[tokenId]] = tokens[tokens.length - 1];
        tokens[tokens.length - 1] = temp;
        tokens.pop();
        delete tokenIdToIndex[tokenId];
        totalSupplies--;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalSupplies;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        uint256[] memory tokens = ownerIndexToTokenId[owner];
        require(tokens.length > index, "index not have token");
        return tokens[index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return indexToTokenId[index];
    }
}
