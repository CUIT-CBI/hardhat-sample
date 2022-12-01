// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

     struct Order {
        address owner;
        uint256 tokenId;
    }

    mapping(uint256 => Order) public orderOfId; // token id to order
    Order[] public orders;
    mapping(uint256 => uint256) public idToOrderIndex; // tokenid to index
    mapping(address => mapping(uint256 => uint256)) IdToIndex; // tokenid to index
    mapping(address => uint256[]) userindex;//address to array 得到tokenid数组 
    function mint(address account, uint256 tokenId) external {
        // TODO
        _mint(account,tokenId);
        idToOrderIndex[tokenId] = orders.length;
        Order memory order = Order(account,tokenId);
        orders.push(order);
        orderOfId[tokenId] = order;
        userindex[account].push(tokenId);
        IdToIndex[account][tokenId] = userindex[account].length - 1;
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(_ownerOf(tokenId) == msg.sender,"not owner");
        userindex[msg.sender][IdToIndex[msg.sender][tokenId]] = userindex[msg.sender][ userindex[msg.sender].length-1];
        userindex[msg.sender].pop();
        delete IdToIndex[msg.sender][tokenId];
        orders[idToOrderIndex[tokenId]] = orders[orders.length-1];
        delete orderOfId[tokenId];
        idToOrderIndex[orderOfId[orders.length-1].tokenId] = idToOrderIndex[tokenId];
        delete idToOrderIndex[tokenId];
        orders.pop();
        _burn(tokenId);
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return orders.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        return userindex[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return orders[index].tokenId;
    }
}
