// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    // 根据用户的index，获取tokenId
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // 所有的 NFT，根据index获取全局的tokenId
    uint256[] private _Tokens;
    mapping(uint256 => uint256) private _TokensIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(tokenId >= 0, "tokenId out of range");
        _mint(account, tokenId);
        _TokensIndex[tokenId] = _Tokens.length;
        _Tokens.push(tokenId);

        uint256 length = ERC721.balanceOf(account);
        _ownedTokens[account][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(ownerOf(tokenId) == msg.sender);
        _burn(tokenId);
        uint256 index = _TokensIndex[tokenId];

        _Tokens[index] = _Tokens[_Tokens.length - 1];
        _TokensIndex[_Tokens[_Tokens.length - 1]] = index;
        _Tokens.pop();
        delete _TokensIndex[index];
        _removeTokenFromOwnerEnumeration(msg.sender, tokenId);
    }

    // burn后的index、tokenid维护
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        uint256 lastTokenIndex = super.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }

        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _Tokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index <= super.balanceOf(owner));
        return _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < this.totalSupply());
        return _Tokens[index];
    }
}
