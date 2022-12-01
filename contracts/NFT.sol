// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    ERC721 public erc;

    mapping(address=> uint256[]) private ownerOftokenId;
    uint256[] private tokenList;
    mapping(uint256 => uint256) private indexOftoken;
    uint256 private count = 1 ;
    
   

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(tokenId>=0);
        require(account != address(0),"mint to zero address");
        require(msg.sender == account);

        _mint(account,tokenId);
        
        
        tokenList.push(tokenId);
        indexOftoken[tokenId] = count - 1;
        
        ownerOftokenId[account].push(tokenId);
        count++;



    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        
        address owner = ownerOf(tokenId);
        require(msg.sender == owner,"No Authority Managment!");
        _burn(tokenId);
        
        


        uint256 index = indexOftoken[tokenId];
        uint256 _token = tokenList[tokenList.length-1];
        indexOftoken[_token] = index;

        tokenList[index] = _token;
        tokenList.pop();
        count--;
        uint len = ownerOftokenId[owner].length;
       for (uint256 i=0;i<len;i++){
           if(ownerOftokenId[owner][i] == tokenId){
               if (i!= len-1){
                   ownerOftokenId[owner][i] = ownerOftokenId[owner][len-1];
               }
               ownerOftokenId[owner].pop();
           }
       }


    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return tokenList.length;
        
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return ownerOftokenId[owner][index];

    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return tokenList[index];
    }
}
