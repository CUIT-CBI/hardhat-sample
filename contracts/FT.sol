// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./ERC721.sol";

contract ZYX is ERC721 {
    uint public MAX_LPLS = 10; // 总量
    address owner;
    uint tokenId;

    // 构造函数
    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner,"not owner");
        _;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://voidtech.cn/i/2022/11/21/xsj7xh.jpg";
    }

    // 铸造函数
    function mint(address to) external onlyOwner {
        tokenId = tokenId + 1;
        require(tokenId >= 0 && tokenId < MAX_LPLS, "tokenId out of range");
        _mint(to, tokenId);
    }
}
