// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint sum=0;
    mapping (uint =>uint) public totalId;
    mapping (address =>mapping(uint => uint))public ownerIndex;
    mapping(address=>uint)public number;
    mapping(uint=>uint)public idToIndex;
    mapping (address =>mapping(uint => uint))public indexOwner;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    
    function mint(address account, uint256 tokenId) external {
        // TODO
        _safeMint(account, tokenId);
        totalId[sum]=tokenId;
        idToIndex[tokenId]=sum;
        sum=sum+1;
        ownerIndex[account][number[account]]=tokenId;
        indexOwner[account][tokenId]=number[account];
        number[account] +=1;
    }

    function burn(uint256 tokenId) external{
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == ownerOf(tokenId),"you are not the owner of this NFT");
        _burn(tokenId);
        sum=sum-1;
        totalId[idToIndex[tokenId]]=totalId[sum];
        totalId[sum]=0;
        number[msg.sender]=number[msg.sender]-1;
        ownerIndex[msg.sender][indexOwner[msg.sender][tokenId]]=ownerIndex[msg.sender][number[msg.sender]];
        ownerIndex[msg.sender][number[msg.sender]]=0;
        
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return sum;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(number[owner] >index,"Error:index overflow");
        return ownerIndex[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(sum > index,"Error:index overflow");
        return totalId[index];
    }
}
