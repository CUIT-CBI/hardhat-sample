// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    mapping(uint256 => uint256) private _ownedTokensIndex;

    uint256[] private _allTokens;

    mapping(uint256 => uint256) private _allTokensIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        require(tokenId >= 0, "tokenId out of range");
        _mint(account, tokenId);
        _allTokensIndex[_allTokens.length] = tokenId;
        _allTokens.push(tokenId);

        uint256 length = ERC721.balanceOf(account);
        _ownedTokens[msg.sender][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(ownerOf(tokenId) == msg.sender);
        _burn(tokenId);
        uint256 index = _allTokensIndex[tokenId];
        // _ownedTokens[msg.sender][index] = 0;

        _allTokens[index] = _allTokens[_allTokens.length - 1];
        _allTokensIndex[_allTokens[_allTokens.length - 1]] = index;
        _allTokens.pop();

        _allTokensIndex[_allTokensIndex[tokenId]] = 0;
        _ownedTokens[msg.sender][_ownedTokensIndex[tokenId]] = 0;

        _ownedTokensIndex[tokenId] = 0;

    }


    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _allTokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return _allTokensIndex[index];
    }
}
