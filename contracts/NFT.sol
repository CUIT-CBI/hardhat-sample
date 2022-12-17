// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint public totalSupply;
    // 声明tokens映射，映射每个拥有者所拥有的代币的标识符列表
    mapping(address => uint256[]) public tokens;
    // 声明tokenOwner映射，映射每个代币的拥有者的地址
    mapping(uint256 => address) public tokenOwner;
    // 声明tokenIndex映射，映射每个代币的标识符在拥有者拥有的代币列表中的索引
    mapping(uint256 => uint256) public tokenIndex;
    // 声明globaIndex映射
    mapping(uint256 => uint256) public globaIndex;


    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        totalSupply = 0;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(tokenOwner[tokenId] == address(0));
        _mint(account,tokenId);
        tokenOwner[tokenId] = account;
        tokens[account].push(tokenId);
        tokenIndex[tokenId] = tokens[account].length;
        totalSupply++;
        globaIndex[totalSupply] = tokenId;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(tokenOwner[tokenId] == msg.sender);
        _burn(tokenId);


        address owner = tokenOwner[tokenId];
        uint256 index = tokenIndex[tokenId];
        uint256[] memory tokens = tokens[owner];

        tokenOwner[tokenId] = address(0);

        if(index==tokens.length-1){
            tokens.pop();
        }else{
            uint256 temp = tokens[index];
            tokens[index] = tokens[tokens.length-1];
            tokens[tokens.length-1] = temp;
            tokens.pop();
        }

        delete tokenIndex[tokenId];

        totalSupply--;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalSupply;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return tokens[owner][index];

    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return globaIndex[index];
    }
}
