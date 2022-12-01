// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256[] total; // 存储所有token的数组
    mapping(address => mapping(uint256 => uint256)) _ownedTokens;
    mapping(uint256 => uint256) _ownerByIndex;
    mapping(uint256 => uint256) _tokenByIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(tokenId>=0,"not in scope");
        _mint(account,tokenId);
        uint256 length = balanceOf(account)-1;
        _ownedTokens[account][length] = tokenId;
        _ownerByIndex[tokenId] = length;
        _tokenByIndex[tokenId] = total.length;
        total.push(tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == ownerOf(tokenId),"not owner");
        _burn(tokenId);
        uint balance = balanceOf(msg.sender);
        uint index = _ownerByIndex[tokenId];
        _ownedTokens[msg.sender][index] = _ownedTokens[msg.sender][balance];
        _ownerByIndex[_ownedTokens[msg.sender][index]] = index;
        delete _ownedTokens[msg.sender][balance];

        uint aIndex = _tokenByIndex[tokenId];
        total[aIndex] = total[total.length-1];
        total.pop();
        _tokenByIndex[total[aIndex]] = aIndex;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return total.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index<balanceOf(owner),"out of range");
        return _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index<total.length,"out of range");
        return _tokenByIndex[index];
    }
}
