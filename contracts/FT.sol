pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract FT is ERC20 {
contract FT is ERC20, Ownable, Pausable {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
    }

    // TODO 实现mint的权限控制，只有owner可以mint
    function mint(address account, uint256 amount) external {

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    // TODO 用户只能燃烧自己的token
    function burn(uint256 amount) external {

        _burn(msg.sender, amount);
    }

    // TODO 加分项：实现transfer可以暂停的逻辑
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        super._beforeTokenTransfer(from, to, amount);

        require(!paused(), "ERC20Pausable: token transfer while paused");
    }

    function pauseTransfer() external onlyOwner {
        _pause();
    }

    function unpauseTransfer() external onlyOwner {
        _unpause();
    }
}
  11  
contracts/NFT.sol
Viewed
@@ -2,21 +2,32 @@
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _counter;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        _safeMint(account, tokenId, "");
        _counter.increment();
    }

    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "Only support burn your NFT");
        _burn(tokenId);
        _counter.decrement();
    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return _counter.current();
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
    }
    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
    }
}
