// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint256 public totalsupply;
    uint256[] public tokenids;
    mapping (uint256 =>uint256) public tokenOfindex; 
    mapping(address => uint256[]) public tokensToUsers;         //每一个用户拥有的所有的tokenId
    mapping (uint256 =>uint256) public tokensOfindex;             
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        _mint(account,tokenId);
        tokenids.push(tokenId);
        tokenOfindex[tokenId]=tokenids.length-1;
        
        tokensToUsers[account].push(tokenId);
        tokensOfindex[tokenId]=tokensToUsers[account].length-1;

        totalsupply++;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender==ownerOf(tokenId));
        if (tokenOfindex[tokenId]==tokenids.length-1){
            tokenids.pop();
            delete tokenOfindex[tokenId];
        }else{
            uint id=tokenOfindex[tokenId];
            uint256 temp =tokenids[id];
            tokenids[id]=tokenids[tokenids.length-1];
            tokenids[tokenids.length-1]=temp;
            tokenids.pop();                  
            tokenOfindex[tokenids[id]]=id;   //更新
            delete tokenOfindex[tokenId];
        }
       if (tokensOfindex[tokenId]==tokensToUsers[msg.sender].length-1){
            tokensToUsers[msg.sender].pop();
            delete tokensOfindex[tokenId];
       }else{
         uint id2 =tokensOfindex[tokenId];
         uint256 temp2=tokensToUsers[msg.sender][id2];
         tokensToUsers[msg.sender][id2]= tokensToUsers[msg.sender][tokensToUsers[msg.sender].length-1];
         tokensToUsers[msg.sender][tokensToUsers[msg.sender].length-1]=temp2;
          tokensToUsers[msg.sender].pop();
         tokensOfindex[tokensToUsers[msg.sender][id2]]=id2;
          delete tokensOfindex[tokenId];
       }
        
        totalsupply--;
        _burn(tokenId);
    }

   
    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
      return totalsupply;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
       return tokensToUsers[owner][index];

    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return tokenids[index];
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        _safeTransfer(from, to, tokenId, data);

          tokensToUsers[to].push(tokenId);
        

         if (tokensOfindex[tokenId]==tokensToUsers[from].length-1){
            tokensToUsers[from].pop();
           tokensOfindex[tokenId]=tokensToUsers[to].length-1;
       }else{
        uint id2 =tokensOfindex[tokenId];
         uint256 temp2=tokensToUsers[from][id2];
         tokensToUsers[from][id2]= tokensToUsers[from][tokensToUsers[from].length-1];
         tokensToUsers[from][tokensToUsers[from].length-1]=temp2;
          tokensToUsers[from].pop();

          tokensOfindex[tokensToUsers[from][id2]]=id2;
          
           tokensOfindex[tokenId]=tokensToUsers[to].length-1;
        
       }
    }
     function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
         tokensToUsers[to].push(tokenId);
      if (tokensOfindex[tokenId]==tokensToUsers[from].length-1){
            tokensToUsers[from].pop();
           tokensOfindex[tokenId]=tokensToUsers[to].length-1;
       }else{
         uint id2 =tokensOfindex[tokenId];
         uint256 temp2=tokensToUsers[from][id2];
         tokensToUsers[from][id2]= tokensToUsers[from][tokensToUsers[from].length-1];
         tokensToUsers[from][tokensToUsers[from].length-1]=temp2;
          tokensToUsers[from].pop();

         tokensOfindex[tokensToUsers[from][id2]]=id2;
          tokensOfindex[tokenId]=tokensToUsers[to].length-1;
        
       }


        _transfer(from, to, tokenId);
    }
   

}
