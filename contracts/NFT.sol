// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    uint public total;
    uint256[] public tokenIds;
    mapping(address => mapping(uint256 => uint256)) private ownerOfToken;
    mapping(uint256 => uint256) private indexOfToken;
    mapping(uint256 => uint256) private indexOfAllToken;
    function mint(address account, uint256 tokenId) external {
        // TODO
        require(msg.sender == account, "address is not the owner");
        uint _index = balanceOf(account);   
        _mint(account, tokenId);
        tokenIds.push(tokenId);
        indexOfAllToken[tokenId] = tokenIds.length - 1;
        ownerOfToken[account][_index] = tokenId;
        indexOfToken[tokenId] = _index;    
        total++;    
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "address is not the owner");
        uint _index = indexOfAllToken[tokenId];
        uint _moveToken = tokenIds[tokenIds.length - 1];
        tokenIds[_index] = _moveToken;
        indexOfAllToken[_moveToken] = _index;
        tokenIds.pop();
        delete indexOfAllToken[tokenId];
        uint index = indexOfToken[tokenId];
        uint moveIndex = balanceOf(owner) - 1;
        uint moveToken = ownerOfToken[owner][moveIndex];
        ownerOfToken[owner][index] = moveToken;
        indexOfToken[moveToken] = index;
        delete ownerOfToken[owner][moveIndex];       
        delete indexOfToken[tokenId];
        _burn(tokenId);
        total--;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return total;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index < balanceOf(owner));
        return ownerOfToken[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < tokenIds.length);
        return tokenIds[index];
    }
}
