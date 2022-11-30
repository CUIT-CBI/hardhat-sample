// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    /*    
        主要思考点在于说   全局token的必要性
            1. 被 burn 的NFT 在全局 token 列表中是否可以被查到
            2. burn 后其他NFT 的索引是否不会被更改
            3. 被 burn 的NFT 是否可以被继续 mint
        
        我的做法是:
            1. 被 burn 的NFT 在全局 token 列表中可以被查到
            2. burn 后 其他NFT 的索引不会被更改
            3. 被 burn 的NFT 不能就被继续 mint
    */
    mapping(address=>uint256[]) _userTokens;
    mapping(address=>mapping(uint256=>uint256)) _userTokenIndex;


    uint256[] _tokens;
    mapping(uint256=>uint) _tokenIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function totalSupply() external view returns (uint256) {
        return _tokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        return _userTokens[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        return _tokens[index];
    }

    function burn(uint256 tokenId) external {
        //用户只能燃烧自己的NF
        require(ownerOf(tokenId)==_msgSender());
        _burn(tokenId);  
    }
    
    

    function mint(address account, uint256 tokenId) external {
        _mint(account,tokenId);
    }

    // 保证代码的通用性 数据一致性 所以 核心逻辑重写在了_burn
    function _burn(uint256 tokenId) internal override {
        address owner = ERC721.ownerOf(tokenId);
        ERC721._burn(tokenId);

        _deleteUserToken(owner, tokenId);
    }    

    // 保证代码的通用性 数据一致性 所以 核心逻辑重写在了_mint
    function _mint(address to, uint256 tokenId) internal override {
        // 保证了 被 burn 的 NFT 不会重新被 mint 
        require(_tokenIndex[tokenId]==0,"The Token has been mint");

        ERC721._mint(to,tokenId);

        _addUserToken(to, tokenId);

        _tokenIndex[tokenId]=_tokens.length;
        _tokens.push(tokenId);
    }

    

    function _addUserToken(address user,uint256 tokenId) internal{
        uint256 userTokenLength=_userTokens[user].length;
        _userTokens[user].push(tokenId);
        _userTokenIndex[user][tokenId]=userTokenLength;
    }

    function _deleteUserToken(address user,uint256 tokenId)internal{
        uint256 userTokenLength=_userTokens[user].length;
        uint256 userTokenIndex=_userTokenIndex[user][tokenId];
        if(userTokenLength-1!=userTokenIndex){
            uint256 lastToken=_userTokens[user][userTokenLength-1];
            _userTokens[user][userTokenIndex]=_userTokens[user][userTokenLength-1];
            _userTokenIndex[user][lastToken]=userTokenIndex;
        }
        delete _userTokenIndex[user][tokenId];
        _userTokens[user].pop();
    }
    


    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        ERC721._transfer(from, to, tokenId);
        _addUserToken(to, tokenId);
        _deleteUserToken(from, tokenId);
    }
}
