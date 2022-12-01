// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    uint256 total;
    struct addressIndexToTokenIndex{
        uint256[] tokenIds;
    }
    addressIndexToTokenIndex[] addressIndexToTokenIndexs;    
    uint256[] alltokenId;
    mapping(uint256 => uint256) private tokenidToIndes;
    mapping(address => uint256) private addressToaddressIndex;
        
    function mint(address account, uint256 tokenId) external {
        // TODO
        if (addressIndexToTokenIndexs.length == 0) {
            addressIndexToTokenIndexs.push();
            addressToaddressIndex[account] = addressIndexToTokenIndexs.length;
            uint256 youraddressIndex = addressToaddressIndex[account] -1;
            tokenidToIndes[tokenId] = alltokenId.length;
            addressIndexToTokenIndexs[youraddressIndex].tokenIds.push(alltokenId.length);  
            alltokenId.push(tokenId);
        }else{
            if (addressToaddressIndex[account] == 0){
                tokenidToIndes[tokenId] = alltokenId.length;
                addressIndexToTokenIndexs.push();
                addressToaddressIndex[account] = addressIndexToTokenIndexs.length;
                uint256 youraddressIndex = addressToaddressIndex[account] -1 ;
                tokenidToIndes[tokenId] = alltokenId.length;
                addressIndexToTokenIndexs[youraddressIndex].tokenIds.push(alltokenId.length);
                alltokenId.push(tokenId);
                
            }else{
                uint256 youraddressIndex = addressToaddressIndex[account] -1;
                tokenidToIndes[tokenId] = alltokenId.length;
                addressIndexToTokenIndexs[youraddressIndex].tokenIds.push(alltokenId.length);
                alltokenId.push(tokenId);
            }
        }
        _mint(msg.sender, tokenId);
        total++;
    }
    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        uint256 youraddressIndex = addressToaddressIndex[msg.sender] - 1;
        uint256 length = addressIndexToTokenIndexs[youraddressIndex].tokenIds.length;
        require(length != 0,'you no have NFT');
        _burn(tokenId);
        uint256 index = tokenidToIndes[tokenId];
        alltokenId[index] = alltokenId[alltokenId.length - 1];
        alltokenId.pop();
        for (uint256 i = 0;i<length;i++){
            if (addressIndexToTokenIndexs[youraddressIndex].tokenIds[i] == index){
                addressIndexToTokenIndexs[youraddressIndex].tokenIds[i] = addressIndexToTokenIndexs[youraddressIndex].tokenIds[length-1];
                addressIndexToTokenIndexs[youraddressIndex].tokenIds.pop();
                break ;
            }
        }
        total--;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return total;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        uint256 youraddressIndex = addressToaddressIndex[owner] - 1;
        require(addressToaddressIndex[owner] != 0,'this owner not have NFT');
        require(addressIndexToTokenIndexs[youraddressIndex].tokenIds.length > index ,'imput error index');
        uint256 tokenIndex = addressIndexToTokenIndexs[youraddressIndex].tokenIds[index];
        return alltokenId[tokenIndex];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(alltokenId.length > index);
        return alltokenId[index];
    }
}
