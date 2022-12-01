// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256 internal totalSupplies;
    uint256 public globalIndex;
    // 全局tokenId下标
    mapping(uint256 => uint256) public tokenIdToGlobalIndex;
    mapping(uint256 => uint256) public indexToTokenId;
    mapping(address => uint256[]) public ownerIndexToTokenId;
    // 此处为了与默认值0区分开来,故index从1开始,若为0说明未被mint
    mapping(uint256 => uint256) public tokenIdToIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        totalSupplies = 0;
        globalIndex = 0;
    }

    function mint(address account, uint256 tokenId) external {
        super._mint(account, tokenId);
        ownerIndexToTokenId[account].push(tokenId);
        // index从1开始
        tokenIdToIndex[tokenId] = ownerIndexToTokenId[account].length;
        // 全局tokenId
        indexToTokenId[globalIndex] = tokenId;
        tokenIdToGlobalIndex[tokenId] = globalIndex;
        // 总供应量
        totalSupplies++;
        // 下标自增
        globalIndex++;
    }

    function burn(uint256 tokenId) external {
        super._burn(tokenId);
        removeList(tokenId);
        totalSupplies--;
    }

    function totalSupply() external view returns (uint256) {
        return totalSupplies;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        uint256[] memory tokens = ownerIndexToTokenId[owner];
        require(tokens.length > index, "index not have token");
        return tokens[index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        return indexToTokenId[index];
    }

    function removeList(uint256 tokenId) internal {
        uint256[] storage tokens = ownerIndexToTokenId[msg.sender];
        // 更新数组下标
        tokenIdToIndex[tokens[tokens.length - 1]] = tokenIdToIndex[tokenId];
        // 更新用户index下的tokenId数组
        uint256 temp = tokens[tokenIdToIndex[tokenId]];
        tokens[tokenIdToIndex[tokenId]] = tokens[tokens.length - 1];
        tokens[tokens.length - 1] = temp;
        tokens.pop();
        // 删除tokenIdToIndex
        delete tokenIdToIndex[tokenId];
        // 删除indexToTokenId
        delete indexToTokenId[tokenIdToGlobalIndex[tokenId]];
        // 删除tokenIdToGlobalIndex
        delete tokenIdToGlobalIndex[tokenId];
    }
}
