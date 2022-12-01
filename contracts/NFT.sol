// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    address public manager;
    uint [] public all;
    mapping(uint => uint ) public allToIndex;//tokenId到index
    mapping(uint => uint)public ownerToIndex;//tokenId到index
    mapping(address => mapping(uint=>uint) ) ownerToTokenId;//owner index 到tokenId
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        manager = msg.sender;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(msg.sender==manager);
        require(tokenId>0);
        _mint(account,tokenId);
        uint256 accountBalance=balanceOf(account);
        all.push(tokenId);
        allToIndex[tokenId]=all.length-1;
        all[allToIndex[tokenId]]=tokenId;
        ownerToIndex[tokenId]=accountBalance-1;
        ownerToTokenId[account][ownerToIndex[tokenId]]=tokenId;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender==ownerOf(tokenId));
        _burn(tokenId);
        for(uint i=allToIndex[tokenId];i<all.length-1;i++){
            all[i]=all[i+1];
            allToIndex[all[i]]--;
        }
        all.pop();//全局数组中删除tokenId
        for(uint j=ownerToIndex[tokenId];j<balanceOf(msg.sender)-1;j++){
             ownerToTokenId[msg.sender][j]=ownerToTokenId[msg.sender][j+1];
             ownerToIndex[ownerToTokenId[msg.sender][j]]--;
        }//改变owner索引
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return all.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index<balanceOf(owner),"out of range");
        return ownerToTokenId[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index<all.length,"out of range");
        return all[index];
    }
}
