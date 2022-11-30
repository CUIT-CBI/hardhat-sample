// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    mapping(uint => uint) private getTokenId;
    uint256 TotalMint = 0;
    function mint(address account, uint256 tokenId) external {
        // TODO
    require(tokenId>=0,"tokenId is mistake Id");
    _mint(account,tokenId);
    // getTokenId(index) = tokenId;
    TotalMint++;
    }


    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        address owner = ownerOf(tokenId);
    require(msg.sender == owner,"only owner to burn");
    _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量

        return TotalMint;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(owner == ownerOf(index),"mistake index");
        return index;
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        
    }
}