// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    mapping(address => mapping(uint256 => uint256)) public _myTokens;
    mapping(uint256 => uint256) public _myTokensIndex;
    uint256[] public _tokens;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        require(tokenId >= 0, "invalid tokenID");
        _mint(account, tokenId);
        uint256 index = balanceOf(account)-1;
        _myTokens[account][index] = tokenId;
        _myTokensIndex[tokenId] = index;
        _tokens.push(tokenId);
    }

    function burn(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId),"you are not the owner");
        _burn(tokenId);
        uint balance = balanceOf(msg.sender);
        uint index = _myTokensIndex[tokenId];
        _myTokens[msg.sender][index] = _myTokens[msg.sender][balance];
        _myTokensIndex[_myTokens[msg.sender][index]] = index;
        delete _myTokens[msg.sender][balance];
        _tokens[index] = _tokens[_tokens.length-1];
        _tokens.pop();
    }

    function totalSupply() external view returns (uint256) {
        return _tokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        require(index < balanceOf(owner),"index out of range");
        return _myTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        require(index < _tokens.length,"index out of range");
        return _tokens[index];
    }
}
