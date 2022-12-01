// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    uint256 _totalmintedcount;
    mapping(uint256 => uint256) public globalIndexOfNft;//全局维护一个index到tokenID的映射
    mapping(uint256 => uint256) public nftOFGlobalIndex;//全局维护一个tokenID到index的映射
    mapping(address => mapping(uint256 => uint256)) public NftOfUser;//对于每个用户维护一个从index到tokenID的映射
    mapping(address => mapping(uint256 => uint256)) public userOfNft;//对于每一个用户维护一个从tokenID到index的映射

    function mint(address account, uint256 tokenId) external {
        // TODO;
        require(account != address(0), "invalid address!");
        require(ownerOf(tokenId) == address(0), "the token had been minted!");

        _mint(account, tokenId);
        _totalmintedcount += 1;
        globalIndexOfNft[_totalmintedcount - 1] = tokenId;
        nftOFGlobalIndex[tokenId] = _totalmintedcount - 1;
        NftOfUser[account][balanceOf(account) - 1] = tokenId;
        NftOfUser[account][tokenId] = balanceOf(account) - 1;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == ownerOf(tokenId), "you are not the owner of this token!");

        _burn(tokenId);
        _totalmintedcount -= 1;
//删除全局表中tokenID对应的nft
        //将全局表中最后一个nft移动到被删除tokenID对应的位置
        globalIndexOfNft[nftOFGlobalIndex[tokenId]] = globalIndexOfNft[_totalmintedcount - 1];
        //将全局表中最后一个nft对应的index修改为最新位置
        nftOFGlobalIndex[globalIndexOfNft[_totalmintedcount - 1]] = nftOFGlobalIndex[tokenId];
        //删除表中最后一个nft的信息
        delete globalIndexOfNft[_totalmintedcount - 1];
        delete nftOFGlobalIndex[tokenId];
//删除用户表中tokenID对应的nft
        //将用户表中最后一个nft移动到被删除tokenID对应的位置
        NftOfUser[msg.sender][userOfNft[msg.sender][tokenId]] = NftOfUser[msg.sender][balanceOf(msg.sender) - 1];
        //将用户表中最后一个nft对应的index修改为最新位置
        userOfNft[msg.sender][NftOfUser[msg.sender][balanceOf(msg.sender) - 1]] = userOfNft[msg.sender][tokenId];
        delete NftOfUser[msg.sender][balanceOf(msg.sender) - 1];
        delete userOfNft[msg.sender][tokenId];

    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _totalmintedcount;

    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return NftOfUser[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return globalIndexOfNft[index];
    }
}
