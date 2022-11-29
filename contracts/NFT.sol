// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    // Token名称
    string public override _name;
    // Token代号
    string public override _symbol;
    //  
    uint256[] public NFTS; 
    //
    mapping(uint256 => uint256) tokenIdToNFTSIndex;
    //  address 到 mapping index 到 tokenId;
    mapping(address => mapping(uint256 => uint256)) private ownerTokens;
    // tokenId 到 owner address 的持有人映射
    mapping(uint => address) private _owners;
    // address 到 持仓数量 的持仓量映射
    mapping(address => uint) private _balances;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _name = name;
        _symbol = symbol;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        super._mint(account,tokenId);

        _balances[account] ++;
        _owners[account] = tokenId;

        NFTS.push(tokenId);
        tokenIdToNFTSIndex[tokenId] = NFTS.length-1;
        uint256 balance = _balances[account];
        ownerTokens[account][balance] = tokenId;

        emit Transfer(address(0), account, tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        super._burn(tokenId);

        _balances[owner] -= 1;
        delete _owners[owner];
        
        removeList(tokenId);
        emit Transfer(owner, address(0), tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        returns NFTS.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return ownerTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return NFTs[index];
    }

    function removeList(uint256 tokenId) internal{
        uint256 NFTSIndex = tokenIdToNFTSIndex[tokenId];
        uint256 NFTS[NFTSIndex] = NFTS[NFTS.length-1];
        NFTS.pop();
        tokenIdToNFTSIndex[tokenId].pop();
        
    }
}
