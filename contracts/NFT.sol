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
    /**
    **/
    mapping(address => Userstoken) AllUsersToken;
    mapping (uint256=>uint256) all;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        uint256 index = balanceOf(account);//获取账户余额
        /** 维护一个 address=>tokenEntity 结构体      
        descrip:
          Entity：
            user_token：                           Token:
                   index ：   外键                   tokenId:主键
                                                     index：外键
                   address  ：外键---|               otherPropertity.......
                                     | 
            User: address ： 主键 ----
        总结:如果token是一个复杂的实体可以把tokens也搞成一个结构体，此时可通过balance获取index从而不关联的前提下存入数据
        **/
        AllUsersToken[account].indexOftoken[tokenId] = index;
        AllUsersToken[account].tokens.push(tokenId);
        
         /** 维护一个 address=>tokenEntity 结构体      
        descrip:
          Entity：
            user_token_index:                         Index
                   id     
                   IndexId---------------------------|id        
                   TmpindexId--------|               index|-----------
                                     |                               |
            user_token：             |         Token:                |  
                   TmpindexId ：外键 |            tokenId:主键        | 
                                                  index---------------|  
                   address  ：外键---|
                                     |
                                     | 
            User: address ： 主键 ----
        上面这种结构只有知道所有的user才能遍历token所以需要进行扩展

        **/
        // 前面的结构可以保证数据存入。但是无法读取。所以需要给中间表建立中间表
        OwnerIndex[account][index] = tokenId;
        // 系统级存储
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
