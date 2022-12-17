// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256[] _total;
    mapping(address => mapping(uint256 => uint256)) _tokensOfOwner;
    mapping(uint256 => uint256) _indexOfOwner;
    mapping(uint256 => uint256) _indexOfToken;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    modifier tokenIdExist {
        require(tokenId >= 0, "No such serial number");
    }

    modifier tokenIsOwner {
        require(msg.sender == ownerOf(tokenId),"error");
    }

    function mint(address account, uint256 tokenId) external tokenIdExist {
        // TODO
        _mint(account,tokenId);
         uint256 length = balanceOf(account)-1;
        _tokensOfOwner[account][length] = tokenId;
        _indexOfOwner[tokenId] = length;
        _indexOfToken[tokenId] = _total.length;
        _total.push(tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
         _burn(tokenId);
        uint balance = balanceOf(msg.sender);
        uint index = _indexOfOwner[tokenId];
        _tokensOfOwner[msg.sender][index] =_tokensOfOwner[msg.sender][balance];
        _indexOfOwner[_tokensOfOwner[msg.sender][index]] = index;
        delete _tokensOfOwner[msg.sender][balance];
        _total[_indexOfToken[tokenId]] = _total[_total.length-1];
        _total.pop();
        _indexOfToken[_total[_indexOfToken[tokenId]]] = _indexOfToken[tokenId];
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _total.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index<balanceOf(owner),"out of range");
        return _tokensOfOwner[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
          require(index < _total.length,"out of range");
        return _indexOfToken[index];
    }
}
