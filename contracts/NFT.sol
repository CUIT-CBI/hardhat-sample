// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    mapping(address => uint256[]) TokensOfAddr;
    uint256 _totalSupply;
    uint256[] tokenIds;
    mapping(uint256 => uint256) IndexOfToken;
    mapping(uint256 => uint256)public indexOfUser;
    function mint(address account, uint256 tokenId) external {
        // TODO
        _totalSupply+=1;
        tokenIds.push(tokenId);
        IndexOfToken[tokenId] =tokenIds.length-1;
        TokensOfAddr[account].push(tokenId);
        indexOfUser[tokenId]=TokensOfAddr[account].length-1;
        _mint(account,tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender==ownerOf(tokenId));
        uint256 temp =IndexOfToken[tokenId];
        uint256 last =tokenIds[tokenIds.length-1];
        tokenIds[temp]=last;
        tokenIds[tokenIds.length-1]=tokenId;
        IndexOfToken[last]=temp;
        delete IndexOfToken[tokenId];
        tokenIds.pop();

        temp = indexOfUser[tokenId];
        last = TokensOfAddr[msg.sender][TokensOfAddr[msg.sender].length-1];
        TokensOfAddr[msg.sender][temp]=last;
        TokensOfAddr[msg.sender][TokensOfAddr[msg.sender].length-1]=tokenId;
        indexOfUser[last]=temp;
        delete indexOfUser[tokenId];
        TokensOfAddr[msg.sender].pop();
        _totalSupply-=1;
        _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _totalSupply;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return TokensOfAddr[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return tokenIds[index];
    }
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        TokensOfAddr[to].push(tokenId);

        uint256 temp = indexOfUser[tokenId];
        uint256 last = TokensOfAddr[from][TokensOfAddr[from].length-1];
        TokensOfAddr[from][temp]=last;
        TokensOfAddr[from][TokensOfAddr[from].length-1]=tokenId;
        indexOfUser[last]=temp;
        indexOfUser[tokenId]=TokensOfAddr[to].length-1;
        TokensOfAddr[from].pop();
        
        _transfer(from, to, tokenId);
    }
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        TokensOfAddr[to].push(tokenId);

        uint256 temp = indexOfUser[tokenId];
        uint256 last = TokensOfAddr[from][TokensOfAddr[from].length-1];
        TokensOfAddr[from][temp]=last;
        TokensOfAddr[from][TokensOfAddr[from].length-1]=tokenId;
        indexOfUser[last]=temp;
        indexOfUser[tokenId]=TokensOfAddr[to].length-1;
        TokensOfAddr[from].pop();
        _safeTransfer(from, to, tokenId, data);
    }
    
}
