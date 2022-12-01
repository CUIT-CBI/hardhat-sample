// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract Link{
    tokenNode private header;
    struct tokenNode {
        uint256 val;
        tokenNode nextNode;
    }
    function getLinkHeader()public pure returns(tokenNode){
        return header;
    }
    function addNode(tokenNode memory node)public{
        tokenNode memory temp=header;
           while(temp.next)
    } 
}
contract NFT is ERC721 {
    uint256 private totalSupplyNumber;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        // tokenId need be not created by anyone
        _mint(account,tokenId);
    }
     function _beforeTokenTransfer(
        address from,
        address to,
        uint256, /* firstTokenId */
        uint256 batchSize
    ) internal override {
        super._beforeTokenTransfer(from,to,0,batchSize);
        if(from==address(0)){
            totalSupplyNumber=totalSupplyNumber++;
        }
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalSupplyNumber;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
    }
}
