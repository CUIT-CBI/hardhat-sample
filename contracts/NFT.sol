// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    address Owner;
    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
         Owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == Owner,"Not Owner");
        _;
    }
    function mint(address account, uint256 tokenId) external onlyOwner{
        // TODO
        _allTokens.push(tokenId);
        _allTokensIndex[tokenId] = _allTokens.length-1;
        uint256 length = balanceOf(account);
        _ownedTokens[account][length] = tokenId;
        _ownedTokensIndex[tokenId]=length;
        _mint(account,tokenId);
    }

    function burn(uint256 tokenId) external onlyOwner{
        // TODO 用户只能燃烧自己的NFT
        uint256 lastTokenIndex=_allTokens.length-1;//处理_allTokens和_allTokensIndex
        uint256 currentTokenIndex=_allTokensIndex[tokenId];
        uint256 lastTokenId = _allTokens[lastTokenIndex];
        _allTokens[currentTokenIndex]=lastTokenId;
        _allTokensIndex[lastTokenId]=currentTokenIndex;
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
        uint256 lastOwnedTokenIndex = balanceOf(Owner) - 1;//处理_ownedTokens和_ownedTokensIndex
        uint256 currentOwnedTokenIndex = _ownedTokensIndex[tokenId];
        if (currentOwnedTokenIndex != lastOwnedTokenIndex) {
            uint256 lastOwnedTokenId = _ownedTokens[Owner][lastOwnedTokenIndex];
            _ownedTokens[Owner][currentOwnedTokenIndex] = lastOwnedTokenId; 
            _ownedTokensIndex[lastOwnedTokenId] = currentOwnedTokenIndex; 
        }
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[Owner][lastOwnedTokenIndex];
        _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        return _allTokens.length;// TODO 获取总mint的NFT的数量
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        require(index < balanceOf(owner),"owner index out of bounds");// TODO 加分项：根据用户的index，获取tokenId
        return  _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        require(index < _allTokens.length,"owner index out of bounds");
        return _allTokens[index];// TODO 根据index获取全局的tokenId
    }
}
