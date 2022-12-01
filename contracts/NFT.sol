// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFT is ERC721 {
    address private _owner;
    uint256 private _totalSupply;
    ERC721Enumerable enumerable;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _owner = _msgSender();
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require (_msgSender() == _owner);
        _mint(account, tokenId);
        _totalSupply++;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        _burn(tokenId);
        
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _totalSupply;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return enumerable.tokenOfOwnerByIndex(owner, index);
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return enumerable.tokenByIndex(index);
    }
}
