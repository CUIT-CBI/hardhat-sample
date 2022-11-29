// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256[] total;
    
    mapping(address => mapping(uint256 => uint256)) TokenOfOwnerByIndex;
    mapping(uint256 => uint256) OwnerByIndex;    
    mapping(uint256 => uint256) TokenByIndex;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
 
        require(tokenId>=0,"not in scope");
        _mint(account,tokenId);
        uint256 length = balanceOf(account)-1;
        TokenOfOwnerByIndex[account][length] = tokenId;
        OwnerByIndex[tokenId] = length;
        TokenByIndex[tokenId] = total.length;
        total.push(tokenId);

    }

    function burn(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId),"not owner");
        _burn(tokenId);
        uint balance = balanceOf(msg.sender);
        uint index = OwnerByIndex[tokenId];
        TokenOfOwnerByIndex[msg.sender][index] = TokenOfOwnerByIndex[msg.sender][balance];
        OwnerByIndex[TokenOfOwnerByIndex[msg.sender][index]] = index;
        delete TokenOfOwnerByIndex[msg.sender][balance];
        
        uint aIndex = TokenByIndex[tokenId];
        total[aIndex] = total[total.length-1];
        total.pop();
        TokenByIndex[total[aIndex]] = aIndex;
    }

    function totalSupply() external view returns (uint256) {
        return total.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        require(index<balanceOf(owner),"out of range");
        return TokenOfOwnerByIndex[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        require(index<total.length,"out of range");
        return TokenByIndex[index];
    }
}
