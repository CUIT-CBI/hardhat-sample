// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    // 全局tokens
    uint256[] public totalTokens;
    // 全局index
    mapping(uint256 => uint256) tokenToGlobalIndex;

    // token的拥有者
    mapping(uint256 => address) _owner;
    // 用户的 tokens
    mapping(address => uint256[]) addressToTokens;
    // token在用户中的  index
    mapping(uint256 => uint256) tokenToUserIndex;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(account != address(0), "mint to zero address");
        require(_owner[tokenId] == address(0), "token already minted");

        // 一个token对应一个地址
        _owner[tokenId] = account;

        // 将token放入用户的背包
        addressToTokens[account].push(tokenId);

        // 该token在的用户index
        tokenToUserIndex[tokenId] = addressToTokens[account].length - 1;

        // 铸造一个 token放进全局 total
        totalTokens.push(tokenId);
        // token放进全局的 全局index
        tokenToGlobalIndex[tokenId] = totalTokens.length - 1;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == _owner[tokenId], "only onwer can burn his token");
        // 找到该 token的拥有者
        address onwer = _owner[tokenId];
        // 将token 移除拥有者的背包
        uint256[] memory userTokens = addressToTokens[onwer];
        uint256 lastToken = userTokens[userTokens.length - 1];
        uint256 index = tokenToUserIndex[tokenId];
        userTokens[index] = lastToken;
        userTokens[userTokens.length - 1] = tokenId;
        addressToTokens[onwer].pop();

        // 将token移除全局 tokens;
        uint256 index1 = tokenToGlobalIndex[tokenId];
        uint256 lastGlobalToken = totalTokens[totalTokens.length - 1];
        totalTokens[index1] = lastGlobalToken;
        totalTokens[totalTokens.length - 1] = tokenId;
        totalTokens.pop();

        delete _owner[tokenId];
        delete tokenToUserIndex[tokenId];
        delete tokenToGlobalIndex[tokenId];
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalTokens.length - 1;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256)
    {
        // TODO 加分项：根据用户的index，获取tokenId

        return addressToTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return totalTokens[index];
    }
}
