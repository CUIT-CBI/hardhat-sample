// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
//tokenid>0&&我们全局的tokenid存放是跟着totalsupply而增加的。
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    // string public  _name;
    // string public  _symbol; 
    //uint public idx=1;//根据idx来获取tokenid
    
    uint256 private totalsupply;
    mapping(address=>mapping(uint256=>uint256)) private useridxtotokenid;//记录每个用户的一个tokenid列表，
    mapping(uint256=>uint256) private idxtotokenid;//全局idx映射tokenid
    mapping(uint256=>uint256) private tokenidtoidx;//全局tokenid映射idx
    mapping(address=>mapping(uint256=>uint256)) private usertokenidtoidx;//每个用户的tokenid映射到的idx
    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        name=name;
        symbol=symbol;
    }

    function mint(address account, uint256 tokenId) external {
        // TODO
        require(account!=address(0));
        require(tokenId>0,"You should mint tokenid that more 0");
        _mint(account,tokenId);
        //创建大于0的id，用tokenid==0表示该tokenid不存在，因为我们delete为软删除，只会置为初始值
        totalsupply+=1;
        useridxtotokenid[account][balanceOf(account)]=tokenId;
        usertokenidtoidx[account][tokenId]=balanceOf(account);
        idxtotokenid[totalsupply]=tokenId;
        tokenidtoidx[tokenId]=totalsupply;
    }   

    function burn(uint256 tokenId) external {

        // TODO 用户只能燃烧自己的NFT 
        address owner=this.ownerOf(tokenId);
        require(msg.sender==owner);
        require(tokenId!=0);
        removeidx(tokenId);
        removeusertokenid(tokenId);
        _burn(tokenId);     
    }
    function totalSupply() external view returns (uint256) {
        // TODO 获取总mint的NFT的数量
       return totalsupply;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        // TODO 加分项：根据用户的index，获取tokenId

        return useridxtotokenid[owner][index];
    }

    function tokenByIndex(uint256 index) external view returns (uint256) {
        // TODO 根据index获取全局的tokenId
        return idxtotokenid[index];
    }
    function removeusertokenid(uint256 tokenId)internal returns (bool){
        //但我们删除一个tokenid时，我们会将最后位置上的tokenid拿到删除的tokenid位置上补上。
        address owner=ownerOf(tokenId);
        uint256  idx = usertokenidtoidx[owner][tokenId];
        //最后一个与当前要删除的进行交换
        uint tid= useridxtotokenid[owner][balanceOf(owner)];
        useridxtotokenid[owner][balanceOf(owner)]=tokenId;
        useridxtotokenid[owner][idx]=tid;
        delete  useridxtotokenid[owner][balanceOf(owner)]; 
        usertokenidtoidx[owner][tokenId]=0;
        usertokenidtoidx[owner][tid]=idx;
        return true;
    }
     function removeidx(uint256 tokenId )internal {
         uint256 idx = tokenidtoidx[tokenId];
         delete tokenidtoidx[tokenId];
         delete idxtotokenid[idx];
     }
}
