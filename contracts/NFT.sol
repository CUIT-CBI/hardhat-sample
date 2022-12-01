// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) public ownerToIndex;
    mapping(uint256 => uint256[]) public indexToTokenid;
    uint256[] tokenArr;
    uint256 _index;
    uint256 tokenNum;

    function mint(address account, uint256 tokenId) external {
        // TODO
        _owners[tokenId] = account;
        //判断账户是否在映射里
        for (uint256 i=0;i<=tokenId;i++) {
            if (account == _owners[i]) {
                break;
            }else{
                _index +=1;
                ownerToIndex[account] = _index;
            }
        }
        //将tokenId加入数组tokenArr
        tokenArr.push(tokenId);
        indexToTokenid[_index] = tokenArr;
        _mint(account,tokenId);
        tokenNum += 1;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == _owners[tokenId]);
        _burn(tokenId);
        delete tokenArr[tokenId-1]; 
        delete _owners[tokenId];
        tokenNum -=1;
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return tokenNum; 
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId

    }
}
