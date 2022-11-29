// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract NFT is ERC721,Ownable {
    mapping(address => uint256)balances;
    // mapping(address => uint256)owners;
    mapping(uint256 => address)owners;
    mapping(address =>mapping(uint256 => uint256))inde;
    mapping(address => mapping(uint256 => uint256))inde1;
    mapping(uint256 =>uint256)index;//由tokenID得到全局下标
    mapping(uint256 => uint256)index1;//由下标到tokenid
    uint256 i=1;
    uint256 _totalSupply;
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }
    function mint(address account, uint256 tokenId) external onlyOwner {
        // TODO
        require(account != address(0));
        require(!_exists(tokenId));
        if(balances[account] != 0){
            inde[account][balances[account]+1] = tokenId;
            inde1[account][tokenId] = balances[account]+1;
        }else{
            inde[account][1] = tokenId;
            inde1[account][tokenId]= 1;
        }
        balances[account]+=1;
        owners[tokenId]=account;
        index1[tokenId]=i;
        index[i]=tokenId;
        _totalSupply+=1;
        i++;
    }

     function balanceOf(address owner) public view override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return balances[owner];
    }
    function ownerOf(uint256 tokenId) public view  override returns (address) {
        address owner = owners[tokenId];
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }
   
    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        address owner = ownerOf(tokenId);
        
        require(owner == msg.sender);
        super._beforeTokenTransfer(owner, address(0), tokenId, 1);
        delete owners[tokenId];
        index[tokenId] = index[_totalSupply];
        delete index[_totalSupply];
        //uint256 a = inde1[msg.sender][tokenId];
        inde[msg.sender][tokenId] = inde[msg.sender][balances[msg.sender]];
        delete inde[msg.sender][balances[msg.sender]];
        balances[owner]-=1;
        _totalSupply-=1;
        i--;

    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _totalSupply;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return inde[owner][index];
    }

    function tokenByIndex(uint256 _index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return index[_index];
    }

}
