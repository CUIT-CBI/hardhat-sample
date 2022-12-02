// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// contract ArrayLink{
//     tokenNode private header;
//     tokenNode private tailer;
//     tokenNode[] private bottomArray;
//     tokenNode[] private idleNode;
//     uint256 private lastLength;
//     struct tokenNode {
//         uint256 val;
//         uint256            nextNode;
//     }
//     constructor(){
//         // o index should be abandoned
//        lastLength=1;
//     }
//     function getLinkHeader()public view returns(tokenNode memory){
//         return header;
//     }
//     function Add(tokenNode memory node)public{
//         if(header.nextNode==0){
//               header=node;
//               bottomArray[1]=node;
//               lastLength=2;
//               return;
//         }
//         if(idleNode)
//         tokenNode memory temp=header;
//            for(;true;){
//               if(temp.nextNode!=0){

//               }                                                                                                                                                                                                                                                                                                                                                                  
//            }
//     }
//     function _SearchTargetElement(tokenNode memory node)internal returns(uint256){
           
//     }
//     function Delete(tokenNode  memory node)external{

//     }
//     function Delete(uint256 index)external{

//     }
// }
contract NFT is ERC721 {
    uint256 private totalSupplyNumber;
    mapping(address=>mapping(uint256=>uint256)) private userTokenOwner;
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
        uint256 tokenId, /* firstTokenId */
        uint256 batchSize
    ) internal override {
        super._beforeTokenTransfer(from,to,0,batchSize);
        if(from==address(this)){
            totalSupplyNumber=totalSupplyNumber++;
        }
        mapping(uint256=>uint256) memory tempUserToken=userTokenOwner[];
        uint256 memory index;
        while(tempUserToken[])
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
