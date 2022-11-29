// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    address contractOwner;
    uint256 public MAX_APES = 100;
    uint256 totalNft = 0;
    uint256 burnNft = 0;
    // index => tokenId
    mapping(address => uint[]) private userTokenId;
    uint[] allTokenId;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        contractOwner = msg.sender;
    }

    function mint(address account, uint256 tokenId) external {
        require(msg.sender == contractOwner, "only the nft contract owner");
        require(tokenId >= 0 && tokenId < MAX_APES, "tokenId out of range");
        userTokenId[msg.sender].push(tokenId);
        allTokenId.push(tokenId);
        totalNft += 1;
        _safeMint(account, tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(_ownerOf(tokenId) == msg.sender, "only burn yourself NFT");
        remove(tokenId);
        remove2(tokenId);
        burnNft+=1;
        _burn(tokenId);
    }

    function remove(uint256 tokenId) public{
        bool b = false;
        for (uint256 i = 0; i < userTokenId[msg.sender].length - 1; i++) {
            if (userTokenId[msg.sender][i] == tokenId) {
                b = true;
            }
            if(b) {
                userTokenId[msg.sender][i] = userTokenId[msg.sender][i+1];
            }
        }
        userTokenId[msg.sender].pop();
    }

    function remove2(uint256 tokenId) public{
        bool b = false;
        for (uint256 i = 0; i < allTokenId.length - 1; i++) {
            if (allTokenId[i] == tokenId) {
                b = true;
            }
            if(b) {
                allTokenId[i] = allTokenId[i+1];
            }
        }
        allTokenId.pop();
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalNft;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256)
    {
        // TODO 加分项：根据用户的index，获取tokenId
        uint256 userTotal = balanceOf(owner);
        require(index < userTotal - 1, "bounding of arrary");
        uint256 tokenId = userTokenId[owner][index];
        return tokenId;
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < totalNft - burnNft);
        uint256 tokenId = allTokenId[index];
        return tokenId;
    }
}
