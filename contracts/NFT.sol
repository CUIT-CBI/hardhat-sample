// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    /*
     当index对应的tokenId为0，则该为没有tokenId已经被燃烧；
        或该index没有对应tokenId
    */
    uint totalSupplies ;
    //每个address对应一个数组
    mapping(address => uint256[]) public ownerIndexToTokenId; 
    //tokenId在数组中对应的下标
    mapping(uint256 => uint256) public tokenIdToIndex;

    //全局中index对应的TokenId，index从1开始
    mapping(uint256 => uint256) public indexToTokenId;
    //tokenId在q全局中对应的index
    mapping(uint256 => uint256) public allTokenIdToIndex;


    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        totalSupplies = 0;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        super._mint(account, tokenId);

        //更新总mint的NFT的数量
        totalSupplies = totalSupplies + 1; 

        //将tokenId加入到address对应的数组中
        ownerIndexToTokenId[account].push(tokenId);

        tokenIdToIndex[tokenId] = ownerIndexToTokenId[account].length - 1;
        
        //全局的tokenId中index的对应关系
        indexToTokenId[totalSupplies] = tokenId;


    }
    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == ERC721.ownerOf(tokenId));
        super._burn(tokenId);
        
        //用户数组tokenId所在位置内容更改为0
        uint256[] storage tokens = ownerIndexToTokenId[msg.sender];
        uint256  _index = tokenIdToIndex[tokenId];
        tokens[_index] = 0;

        //更新全局数组中tokenId所在位置状态
        uint256 _allIndex = allTokenIdToIndex[tokenId];
        indexToTokenId[_allIndex] = 0;

    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalSupplies;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        uint256[] memory addressToTokenIds = ownerIndexToTokenId[owner];
        require(addressToTokenIds.length-1 >= index);
        return addressToTokenIds[index];

    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return indexToTokenId[index];
    }
}
