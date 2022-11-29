// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    
    function mint(address account, uint256 tokenId) external {
        // TODO
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
    }
}
