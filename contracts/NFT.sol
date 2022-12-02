pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    address manager;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        manager = msg.sender;
    }
    uint public MAX_NFTS = 100;
   
    //nft都有各自的索引号，定义在合约的allnfts数组。
    uint256[] internal allnfts;
    //将nftId映射到全局的allnfts数组上
    mapping(uint256 => uint256) internal allnftsIndex;
    //用户地址映射到所拥有Nft的数组上
    mapping(address => uint256[]) internal ownednfts;
    //用户nftid映射数组上的index
    mapping(uint256=>uint256) ownednftIndex;
    
    function mint(address account, uint256 tokenId) external {
        // TODO
        uint256 index = ownednftIndex[tokenId];
        require(msg.sender == manager ,"Not owner");
        require(tokenId >= 0 && tokenId < MAX_NFTS, "tokenId out of range");
        _mint(account,tokenId);
        allnftsIndex[tokenId] = allnfts.length;
        allnfts.push(tokenId);
        ownednfts[account].push(tokenId);
    }
    
    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        address owner = ownerOf(tokenId);
        uint256 _index = allnftsIndex[tokenId];
        uint256 index = ownednftIndex[tokenId];
        uint256 LastTokenId = allnfts[(allnfts.length-1)];
        uint256 _LastTokenId = ownednfts[owner][ownednfts[owner].length-1];
        require(msg.sender == owner,"Not owner");
        _burn(tokenId);
        //全局数组的改变
        if(allnfts.length != 1){
           allnfts[(allnfts.length-1)] = allnfts[_index];
           allnfts[_index] = LastTokenId;
        }
        allnfts.pop();
        //用户数组的改变
        if(ownednfts[owner].length != 1){
           ownednfts[owner][ownednfts[owner].length-1] = ownednfts[owner][index];
           ownednfts[owner][index] = _LastTokenId;
        }
        ownednfts[owner].pop();
    }

    function totalSupply() public view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return allnfts.length;

    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        require(index < ERC721.balanceOf(owner), "owner index out of bounds");
        return ownednfts[owner][index];
        
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < totalSupply(), "global index out of bounds");
        return allnfts[index];
    }
    
}
