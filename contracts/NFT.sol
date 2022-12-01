// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    mapping(address => mapping(uint256 => uint256)) _ownedTokens;
    mapping(uint256 => uint256) _ownedTokensIndex;
    uint256 [] _allTokens;
    mapping(uint256 => uint256) _allTokensIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(tokenId >= 0);
        _mint(account, tokenId);
        uint256 length = balanceOf(account) - 1;
        _allTokens.push(tokenId);
        _ownedTokens[account][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
        _allTokensIndex[tokenId] = _allTokens.length;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == ownerOf(tokenId));
        _burn(tokenId);
        uint256 Remaining = balanceOf(msg.sender);
        uint256 index = _ownedTokensIndex[tokenId];
        // burn会令Remaining-1
        _ownedTokens[msg.sender][index] = _ownedTokens[msg.sender][Remaining];
        _ownedTokensIndex[_ownedTokens[msg.sender][index]] = index;
        delete _ownedTokens[msg.sender][Remaining];
        uint256 purposeIndex = _allTokensIndex[tokenId];
        _allTokens[purposeIndex] = _allTokens[_allTokens.length - 1];
        _allTokens.pop();
        _allTokensIndex[_allTokens[purposeIndex]] = purposeIndex;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _allTokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index < balanceOf(owner));
        return _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < _allTokens.length);
        return _allTokens[index];
    }
}
