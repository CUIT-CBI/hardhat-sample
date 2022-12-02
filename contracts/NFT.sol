// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    // token在所有人持有token里的index
    mapping(uint256 => uint256) public _tokenIDToIndex;
    // 查找每个用户持有代币的列表
    mapping(address => mapping(uint256 => uint256)) public _tokenList;
    // 存储所有token的数组
    uint256[] public _allTokens;
    // 每个token在_allTokens数组中的index
    mapping(uint256 => uint256) public  _allTokensIndex;

    function mint(address account, uint256 tokenId) external {
        // TODO
        _mint(account,tokenId);
        _allTokens.push(tokenId);
        _allTokensIndex[tokenId] = _allTokens.length - 1;
        uint256 length = balanceOf(account);
        _tokenIDToIndex[tokenId] = length - 1;
        _tokenList[account][length - 1] = tokenId;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "U are not the tokne's Owner!");
        uint256 preindex = _allTokensIndex[tokenId];
        uint256 lastToken = _allTokens[_allTokens.length - 1];
        _burn(tokenId);
        _allTokens.pop();
        _allTokens[preindex] = lastToken;
        uint256 indexInList = _tokenIDToIndex[tokenId];
        _tokenList[owner][indexInList] = _tokenList[owner][balanceOf(owner)];
        delete _tokenList[owner][balanceOf(owner)];
        _tokenIDToIndex[balanceOf(owner)] = _tokenIDToIndex[tokenId];
        delete _tokenIDToIndex[tokenId];
        delete _allTokensIndex[tokenId];
    }
    
    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _allTokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index < balanceOf(owner));
        return _tokenList[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < _allTokens.length);
        return _allTokens[index];
    }
}
