// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256 public amount;
    mapping (address=>mapping (uint256=> uint256)) OwnerIndex;

    struct Userstoken {
        mapping (uint256=>uint256) indexOftoken;
        uint256[] tokens;
    }
    mapping(address => Userstoken) AllUsersToken;
    mapping (uint256=>uint256) all;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        uint256 index = balanceOf(account);
        AllUsersToken[account].indexOftoken[tokenId] = index;
        AllUsersToken[account].tokens.push(tokenId);
        OwnerIndex[account][index] = tokenId;
        all[amount] = tokenId;
        amount++;
        _mint(account, tokenId);
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(ownerOf(tokenId) == msg.sender);
        uint256 index =  AllUsersToken[msg.sender].indexOftoken[tokenId];
        uint256 len =  AllUsersToken[msg.sender].tokens.length -1;
        if(len == index){                                         
            AllUsersToken[msg.sender].tokens.pop();
            delete  OwnerIndex[msg.sender][index];
            delete  AllUsersToken[msg.sender].indexOftoken[tokenId];
        }else{
            uint256 tokenNow = AllUsersToken[msg.sender].tokens[len];
            AllUsersToken[msg.sender].tokens[index] = AllUsersToken[msg.sender].tokens[len];    //交换位置

            OwnerIndex[msg.sender][index] =tokenNow;   
            delete OwnerIndex[msg.sender][len];

            delete  AllUsersToken[msg.sender].indexOftoken[tokenId];
            AllUsersToken[msg.sender].indexOftoken[tokenNow] = index;     
                                 
            AllUsersToken[msg.sender].tokens.pop(); 
        }
         _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return amount;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return OwnerIndex[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return all[index];
    }
}
