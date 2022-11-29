// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    uint256[] tokenOfIndex;
    mapping(uint256=>uint256) tokenToIndex;
    mapping(address=>uint256[]) tokenOfOwnerByIndex1;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        ERC721._mint(account,tokenId);
        tokenOfIndex.push(tokenId);
        tokenToIndex[tokenId] = tokenOfIndex.length - 1;
        tokenOfOwnerByIndex1[account].push(tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(ownerOf(tokenId) == msg.sender,"you can't burn others NFT!");
        ERC721._burn(tokenId);
        uint256 index = tokenToIndex[tokenId];
        if (index != tokenOfIndex.length-1){
            uint256 lastTokenId = tokenOfIndex[tokenOfIndex.length-1];
            tokenOfIndex[index] = lastTokenId;
        }
        if (index != tokenOfOwnerByIndex1[msg.sender].length -1){
            uint256 lastTokenId = tokenOfOwnerByIndex1[msg.sender][tokenOfOwnerByIndex1[msg.sender].length -1];
            tokenOfOwnerByIndex1[msg.sender][index] = lastTokenId;
        }
        tokenOfIndex.pop();
        tokenOfOwnerByIndex1[msg.sender].pop();
        delete tokenToIndex[tokenId];

    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return tokenOfIndex.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index < tokenOfOwnerByIndex1[owner].length,"the index you input is out of length!");
        return tokenOfOwnerByIndex1[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < tokenOfIndex.length,"the index you input is out of length!");
        return tokenOfIndex[index];
    }
}
