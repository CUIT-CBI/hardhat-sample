// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    uint private total;

    uint256[] private tokenIds;

    mapping(address => mapping(uint256 => uint256)) private ownerOfToken;
    mapping(uint256 => uint256) private indexOfToken;

    mapping(uint256 => uint256) private indexOfAllToken;

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(msg.sender == account, "is nor owner");
        uint _index = balanceOf(account);   

        _mint(account, tokenId);
        tokenIds.push(tokenId);
        indexOfAllToken[tokenId] = tokenIds.length - 1;

        ownerOfToken[account][_index] = tokenId;
        indexOfToken[tokenId] = _index;    
        total++;    
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        address user = ownerOf(tokenId);
        require(msg.sender == user, "is not owner");

        uint _index = indexOfAllToken[tokenId];
        uint _changeToken = tokenIds[tokenIds.length - 1];
        tokenIds[_index] = _changeToken;
        indexOfAllToken[_changeToken] = _index;
        tokenIds.pop();
        delete indexOfAllToken[tokenId];

        uint index = indexOfToken[tokenId];
        uint changeIndex = balanceOf(user) - 1;
        uint changeToken = ownerOfToken[user][changeIndex];
        ownerOfToken[user][index] = changeToken;
        indexOfToken[changeToken] = index;
        delete ownerOfToken[user][changeIndex];       
        delete indexOfToken[tokenId];

        _burn(tokenId);
        total--;

    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return total;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
       
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        require(index < tokenIds.length, "do not have this index");
        return tokenIds[index];
    }
}