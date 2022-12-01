// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    uint256 TotalSupply = 0;
    
    function mint(address account, uint256 tokenId) external {
        // TODO
        _mint(account,tokenId); 
        TotalSupply = TotalSupply+1;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == ownerOf(tokenId),"This must owner of tokenId");
        _burn(tokenId);
        
    }
    function totalSupply() external view returns (uint256 _totalSupply) {
        // TODO 获取总mint的NFT的数量
      return TotalSupply;
         
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
    }
}
