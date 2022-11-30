// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    address owner;
    uint256 numOfToken;
    uint256[] NFTList;
    mapping(address => uint256[]) ownerIndexToTokenId;
    mapping(uint256 => uint256) tokenIdToOwnerIndex;
    mapping(uint256 => uint256) indexToTokenId;
    mapping(uint256 => uint256) tokenIdToIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = msg.sender;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(msg.sender == owner,"you can't mint the token");
        _mint(account,tokenId);
        numOfToken++;
        NFTList.push(tokenId);
        ownerIndexToTokenId[account].push(tokenId);
        tokenIdToOwnerIndex[tokenId] = ownerIndexToTokenId[account].length - 1;
        indexToTokenId[NFTList.length - 1] = tokenId;
        tokenIdToIndex[tokenId] = NFTList.length - 1;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == ownerOf(tokenId));
        _burn(tokenId);
        if(tokenIdToIndex[tokenId] == (NFTList.length-1)){
            NFTList.pop();
            delete indexToTokenId[tokenIdToIndex[tokenId]];
            delete tokenIdToIndex[tokenId];
        }else{
            NFTList[tokenIdToIndex[tokenId]] = NFTList[NFTList.length-1];
            tokenIdToIndex[NFTList[NFTList.length-1]] = tokenIdToIndex[tokenId];
            indexToTokenId[tokenIdToIndex[tokenId]] = NFTList[NFTList.length-1];
            NFTList.pop();
            delete indexToTokenId[tokenIdToIndex[tokenId]];
            delete tokenIdToIndex[tokenId];
        }
        if(tokenIdToOwnerIndex[tokenId] == ownerIndexToTokenId[msg.sender].length-1){
            ownerIndexToTokenId[msg.sender].pop();
            delete tokenIdToOwnerIndex[tokenId];
        }else{
            uint256 length = ownerIndexToTokenId[msg.sender].length - 1;
            ownerIndexToTokenId[msg.sender][tokenIdToOwnerIndex[tokenId]] = ownerIndexToTokenId[msg.sender][length];
            tokenIdToOwnerIndex[ownerIndexToTokenId[msg.sender][length]] = tokenIdToOwnerIndex[tokenId];
            ownerIndexToTokenId[msg.sender].pop();
            delete tokenIdToOwnerIndex[tokenId];
        }
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return numOfToken;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index <= ownerIndexToTokenId[_owner].length - 1,"you don't have the token!");
        return ownerIndexToTokenId[_owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index <= NFTList.length - 1,"Don't have this token!");
        return NFTList[index];
    }
}
