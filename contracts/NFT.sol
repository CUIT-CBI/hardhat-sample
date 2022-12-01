// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    mapping(uint256 => uint256) private _allTokenId;
    mapping(uint256 => uint256) private _tokenIdtoIndex;
    mapping(address => mapping(uint256 => uint256)) _indexOwnertoTokenId;
    uint256[] public tokens;
    uint256 _index;
    uint256 _totalSupply;

    struct ownerTokenId{
        address account;
        uint256 tokenId;
        uint256[] ownerIndex;
    }

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    
    function mint(address account, uint256 tokenId) external{
        // TODO
        uint256 index = balanceOf(account);
        tokens.push(tokenId);
        _tokenIdtoIndex[tokenId] = index;
        _indexOwnertoTokenId[account][index] = tokenId;
        _allTokenId[_index] = tokenId;
        _safeMint(account, tokenId);
        _totalSupply ++;
        _index ++;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(ownerOf(tokenId) == msg.sender);
        uint256 index = _tokenIdtoIndex[tokenId];
        uint256 len = tokens.length - 1;
        uint256 lastindex = balanceOf(msg.sender);
        _allTokenId[index] = tokens[len];
        _indexOwnertoTokenId[msg.sender][index] = _indexOwnertoTokenId[msg.sender][lastindex-1];
        tokens[index] = tokens[tokens.length-1];
        delete _allTokenId[len];
        delete _indexOwnertoTokenId[msg.sender][lastindex-1];
        delete _tokenIdtoIndex[tokenId];
        tokens.pop();
        _burn(tokenId);
        _totalSupply --;
    }
function test() external view returns(uint256){
    uint256 l = balanceOf(msg.sender);
    return _allTokenId[l];
}
    function totalSupply() external view returns (uint256 totalSupply) {
        // TODO 获取总mint的NFT的数量
        return _totalSupply;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return _indexOwnertoTokenId[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return _allTokenId[index];
    }
}

