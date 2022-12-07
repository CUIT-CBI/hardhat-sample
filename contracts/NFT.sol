// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
   
    string public _name;
    string public _symbol; 
    uint256[] public NFTS; 
    mapping(uint256 => uint256) tokenIdToNFTSIndex;
    mapping(address => mapping(uint256 => uint256)) private ownerTokens;
    mapping(uint256 => uint256) private tokenIdToOwnerIndex;
  
    mapping(uint => address) private _owners;

    mapping(address => uint) private _balances;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _name = name;
        _symbol = symbol;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        super._mint(account,tokenId);

        _balances[account] ++;
        _owners[tokenId] = account;

        NFTS.push(tokenId);
        tokenIdToNFTSIndex[tokenId] = NFTS.length-1;
        uint256 balance = _balances[account];
        ownerTokens[account][balance] = tokenId;
        tokenIdToOwnerIndex[tokenId] = balance;

        emit Transfer(address(0), account, tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        super._burn(tokenId);

        _balances[msg.sender] -= 1;
        delete _owners[tokenId];
        
        removeList(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return NFTS.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return ownerTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return NFTS[index];
    }

}
