// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    //两个index，用户地址下的index代表用户持有的第几个nft，全局index代表nft在总量池的位置

    //管理员账户
    address private admin;
    //token总量
    uint256 tokenIdCount;

    //注：作者强迫症，index以1开始
    // Mapping owner address to token count
    mapping(address => uint256) _balances;
    //tokenId对应的address
    mapping(uint256 => address) _owners;

    //用户地址下根据index的token
    mapping(address => mapping(uint256 => uint256)) userAccount;
    //用户地址下tokenID对应的index
    mapping(address => mapping(uint256 => uint256)) userIndex;

    //全局index对应的tokenID
    mapping(uint256 => uint256) tokenIds;
    //token对应下的index
    mapping(uint256 => uint256) tokenIdIndex;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        admin = msg.sender;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(admin == msg.sender, "Only the administrator address can be called!");
        _mint(account,tokenId);

        tokenIdCount = tokenIdCount + 1;

        //维护变量
        _balances[account] ++;
        _owners[tokenId] = account;

        userAccount[account][_balances[account]] = tokenId;
        userIndex[account][tokenId] = _balances[account];

        tokenIds[tokenIdCount] = tokenId;
        tokenIdIndex[tokenId] = tokenIdCount;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(_owners[tokenId] == msg.sender, "You can only destroy your own");
        if(userIndex[msg.sender][tokenId] == _balances[msg.sender]){
            delete userIndex[msg.sender][tokenId];
            delete userAccount[msg.sender][_balances[msg.sender]];
        }else{
            uint256 _end = _balances[msg.sender];
            uint256 _tokenIndex = userIndex[msg.sender][tokenId];
            uint256 _endTokenId = userAccount[msg.sender][_end];

            userIndex[msg.sender][_endTokenId] = _tokenIndex;
            delete userIndex[msg.sender][tokenId];
            userAccount[msg.sender][_tokenIndex] = _endTokenId;
            delete userAccount[msg.sender][_end];
        }

        if(tokenIdIndex[tokenId] == tokenIdCount){
            delete tokenIdIndex[tokenId];
            delete tokenIds[tokenIdCount];
        }else{
            uint256 _tokenIndexs = tokenIdIndex[tokenId];
            uint256 _endTokenIds = tokenIds[tokenIdCount];

            tokenIdIndex[_endTokenIds] = _tokenIndexs;
            delete tokenIdIndex[tokenId];
            tokenIds[_tokenIndexs] = _endTokenIds;
            delete tokenIds[tokenIdCount];
        }
        
        tokenIdCount --;
        _balances[msg.sender] --;
        delete _owners[tokenId];
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return tokenIdCount;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return userAccount[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return tokenIds[index];
    }
}
