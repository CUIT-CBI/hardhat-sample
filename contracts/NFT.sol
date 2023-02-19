import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    /*
     当index对应的tokenId为0，则该为没有tokenId已经被燃烧；
        或该index没有对应tokenId
    */
    uint totalSupply ;
    mapping(address => uint256[]) public ownerIndexToken; 
    mapping(uint256 => uint256) public tokenIdIndex;
    mapping(uint256 => uint256) public indexToken;
    mapping(uint256 => uint256) public allTokenIdIndex;


    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        totalSupply = 0;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
    }
        super._mint(account, tokenId);

        //更新总mint的NFT的数量
        totalSupply = totalSupply + 1; 

        //将tokenId加入到address对应的数组中
        ownerIndexToken[account].push(tokenId);

        tokenIdIndex[tokenId] = ownerIndexToken[account].length - 1;

        //全局的tokenId中index的对应关系
        indexToken[totalSupply] = tokenId;


    }
    function burn(uint256 tokenId) external {
        // TODO 用户只能燃烧自己的NFT
        require(msg.sender == ERC721.ownerOf(tokenId));
        super._burn(tokenId);

        //用户数组tokenId所在位置内容更改为0
        uint256[] storage tokens = ownerIndexToken[msg.sender];
        uint256  _index = tokenIdIndex[tokenId];
        tokens[_index] = 0;

        //更新全局数组中tokenId所在位置状态
        uint256 _allIndex = allTokenIdIndex[tokenId];
        indexTokenId[_allIndex] = 0;

    }

    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
        return totalSupply;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId
        uint256[] memory addressTokens = ownerIndexToken[owner];
        require(addressTokens.length-1 >= index);
        return addressTokens[index];

    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return indexToken[index];
    }

