// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256 totalMintNFT;
    uint256 index1;
    //加分项
    uint256 index2;
    //通过用户的address，获取tokenId
    mapping(address => uint256[]) public ownerIndexTokenId;
    //通过用户的tokenID，获取在uint256[]的index2   
    mapping(uint256 => uint256) public tokenIdToIndex2;

    //通过根据index获取全局的tokenId
    mapping(uint256 => uint256) public indexTokenId ;
    //通过tokenId获取用户的index
    mapping(uint256 => uint256) public tokenIdToIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
      totalMintNFT=0;
      index1=0;
      index2=0;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        ERC721._mint(account,tokenId);
        //总mint的NFT的数量
        totalMintNFT++;
        //加分项
        ownerIndexTokenId[account].push(tokenId);
        tokenIdToIndex2[tokenId]=index2;
        index2++;

        indexTokenId[index1]=tokenId;
        tokenIdToIndex[tokenId]=index1;
        index1++;
        
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        ERC721._burn(tokenId);
        //加分项
        uint256[] storage arrayTokenId =  ownerIndexTokenId[msg.sender];
        arrayTokenId[tokenIdToIndex2[tokenId]] = arrayTokenId[index2-1];
        arrayTokenId.pop();
        delete arrayTokenId[tokenIdToIndex2[tokenId]];
        delete  arrayTokenId[index2-1];
        index2--;

        uint256 _index = tokenIdToIndex[tokenId];
        indexTokenId[_index] = indexTokenId[index1-1];
        tokenIdToIndex[tokenId]=_index;
        delete tokenIdToIndex[tokenId];
        delete indexTokenId[_index];
        index1--;
        totalMintNFT--;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
       return totalMintNFT;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
          uint256[] storage arrayTokenId =  ownerIndexTokenId[msg.sender];
          require(arrayTokenId.length >= index);
          return arrayTokenId[index];
       
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return indexTokenId[index];
    }
}
