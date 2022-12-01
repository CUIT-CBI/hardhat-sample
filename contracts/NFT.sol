// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint private tokenNumber;

    mapping(uint256 => uint256) tokenIdOfIndex;//tokeid => index
    mapping(address => mapping(uint => uint)) tokeIdByIndex; // address => index => tokeid总数

    //全局tokens数组
    uint[] private tokens;
    mapping (uint256 => uint256) globalTokeOfIndex; //tokenId => index

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        require(msg.sender == account);

        uint indexAll = balanceOf(account);
        tokeIdByIndex[account][indexAll] = tokenId;
        tokenIdOfIndex[tokenId] = indexAll;

        //修改合约代码，使得只有owner才可以mint
        _mint(account,tokenId);
        //添加token到数组
        tokens.push(tokenId);
        //维护mapping
        globalTokeOfIndex[tokenId] = tokens.length - 1;

        tokenNumber++;
    }

    function burn(uint256 tokenId) external {
        // 用户只能燃烧自己的NFT
        require(ownerOf(tokenId) == msg.sender);
        //获取NFT的主人
        address owner = ownerOf(tokenId);
        //获取最后一个NFT的下标
        uint256 lastIndex = balanceOf(owner) - 1;
        //最后一个的tokenID
        uint256 tokeIdLast = tokeIdByIndex[owner][lastIndex];
        //获取tokenId的对应的index
        uint256 index = tokenIdOfIndex[tokenId];
        //将要burn的NFT替换为最后一个tokenId
        tokeIdByIndex[owner][index] = tokeIdLast;
        //删除burn的NFT
        delete tokeIdByIndex[owner][lastIndex];
        delete tokenIdOfIndex[tokenId];
        //维护tokenIdOfIndex 
        tokenIdOfIndex[tokeIdLast] = index;

        //获取数组最后一个token的下标
        uint256 globalLastIndex = tokens.length - 1;
        //获取数组最后一个tokenId
        uint256 globalTokenIdLast = tokens[globalLastIndex];
        //得到burn的token的下标
        uint256 globalIndex = globalTokeOfIndex[tokenId];
        //将burn的token替换为最后一个
        tokens[globalIndex] = globalTokenIdLast;
        //将数组最后一个token移除
        tokens.pop();
        //维护mapping
        globalTokeOfIndex[globalTokenIdLast] = globalIndex;
        delete globalTokeOfIndex[tokenId];

        _burn(tokenId);
        tokenNumber--;
    }

    function totalSupply() external view returns (uint256) {
        // 获取总mint的NFT的数量
        return tokenNumber;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // 加分项：根据用户的index，获取tokenId
        //获取NFT的总量
        require(index < balanceOf(owner));
        return tokeIdByIndex[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < tokens.length);
        return tokens[index];
    }
}
