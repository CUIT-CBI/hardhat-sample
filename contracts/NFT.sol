// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

     struct Token {
        address userAddress;
        uint256 userTokenId;
    }

    mapping(uint256 => Token) orderOfId;
    Token[] Tokens;
    mapping(uint256 => uint256) tokenIdToIndex;
    mapping(address => mapping(uint256 => uint256)) IdToIndex;
    mapping(address => uint256[]) user;
    function mint(address account, uint256 tokenId) external {
        // TODO
        tokenIdToIndex[tokenId] = Tokens.length;
        Tokens.push(Token(account,tokenId));
        orderOfId[tokenId] = Token(account,tokenId);
        user[account].push(tokenId);
        IdToIndex[account][tokenId] = user[account].length - 1;
        _mint(account,tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        uint256 index;
        require(ownerOf(tokenId) == msg.sender);
        for(uint256 i =0;i<user[msg.sender].length;i++){
            if(i==IdToIndex[msg.sender][tokenId]){
                continue;
            }else{
                user[msg.sender][index] = user[msg.sender][i];
                index++;
            }
        }
        /**以下写法会乱序
         Tokens[tokenIdToIndex[tokenId]] = Tokens[Tokens.length-1];
         user[msg.sender][IdToIndex[msg.sender][tokenId]] = user[msg.sender][user[msg.sender].length-1];
         */
        user[msg.sender].pop();
        index =0;
        delete IdToIndex[msg.sender][tokenId];
        for(uint256 i =0;i<Tokens.length;i++){
            if(i==tokenIdToIndex[tokenId]){
                continue;
            }else{
                Tokens[index] = Tokens[i];
                tokenIdToIndex[Tokens[index].userTokenId] = index;
                index++;
            }
        }
        delete orderOfId[tokenId];
        delete tokenIdToIndex[tokenId];
        Tokens.pop();
        _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return Tokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return user[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return Tokens[index].userTokenId;
    }
}
