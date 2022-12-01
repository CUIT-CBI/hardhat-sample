// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    uint256[] totalToken; 
    mapping(address => mapping(uint256 => uint256)) _ownedTokens;
    mapping(uint256 => uint256) _ownerIndex;
    mapping(uint256 => uint256) _tokenIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(tokenId>=0,"not in scope");
        _mint(account,tokenId);
        uint256 length = balanceOf(account)-1;
        _ownedTokens[account][length] = tokenId;
        _ownerIndex[tokenId] = length;
        _tokenIndex[tokenId] = totalToken.length;
        totalToken.push(tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只自己能燃烧的NFT
        require(msg.sender == ownerOf(tokenId),"Not owner");
        _burn(tokenId);
        uint balance = balanceOf(msg.sender);
        uint index = _ownerByIndex[tokenId];
        _ownedTokens[msg.sender][index] = _ownedTokens[msg.sender][balance];
        _ownerIndex[_ownedTokens[msg.sender][index]] = index;
        delete _ownedTokens[msg.sender][balance];

        uint aIndex = _tokenIndex[tokenId];
        totalToken[aIndex] = totalToken[totalToken.length-1];
        totalToken.pop();
        _tokenIndex[totalToken[aIndex]] = aIndex;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalToken.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index<balanceOf(owner),"Out of range");
        return _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index<totalToken.length,"Out of range");
        return _tokenIndex[index];
    }
}
