import '../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol';
import "./myToken.sol";
import "forge-std/console.sol";
contract NFT {
    address private owner ;
    ERC721 public  NFT_TOKEN;
    uint public startingBid;
    uint public endingBid;
    uint public startingPrice;
    uint  public tokenId;
    bool  public started;
    struct Object {
        address _address;
        uint256 amount;
    }
    struct Object2 {
        bool isExist;
        uint256 amount;
    }
    mapping(address => Object2) public balances;
    Object[] public maxStack;
    constructor() {
        owner = msg.sender;
    }
     modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }
    function start(address _NFT_TOKEN, uint _endingBid, uint _startingPrice ,uint _tokenId) external onlyOwner {
        NFT_TOKEN = ERC721(_NFT_TOKEN);
        endingBid = _endingBid;
        startingPrice = _startingPrice;
        tokenId = _tokenId;
       NFT_TOKEN.transferFrom(owner , address(this),tokenId);
       started = true;
    }
    function addToBalances(address _addr, Object2 memory obj) internal {
        if (balances[_addr].isExist) {
            payable(msg.sender).transfer(balances[_addr].amount);
        }
        balances[_addr] = obj;
    }
    function getAddressValue(address _addr) public view returns (bool) {
        return balances[_addr].isExist;
    }
    function updateMax() internal {
        while (maxStack.length > 0 && !balances[maxStack[maxStack.length - 1]._address].isExist) {
            maxStack.pop();
        }
    }
     function  addQuote()  public payable{
        console.log("user" , msg.sender , "amount" , msg.value);
        require(started && block.timestamp < endingBid, "the Auction is closed");
          
        updateMax();
        if(maxStack.length>1)
     
       { 
           console.log("zzz");
        require(msg.value > maxStack[maxStack.length - 1].amount, "the price is too low");
       }
        else
           {
           require(msg.value > startingPrice, "the price is too low");
           }
       
        Object memory newObj = Object(address(msg.sender), msg.value);
        maxStack.push(newObj);
        Object2 memory newObj2 = Object2(true, msg.value);
       
        addToBalances(address(msg.sender), newObj2);
           console.log("userrr" , msg.sender , "amount" , msg.value);
          
       
    }
    function cancelQuote() public {
        require(started && block.timestamp < endingBid, "the Auction is closed");
        require(balances[address(msg.sender)].isExist, "you are not exist");
        balances[address(msg.sender)].isExist = false;
        payable(msg.sender).transfer(balances[address(msg.sender)].amount);
    }
    function returnQuotes() public {
        require(block.timestamp > endingBid, "the Auction is active");
        updateMax();
      for(uint i=0;i<maxStack.length-1;i++){
        payable(address(maxStack[i]._address)).transfer(maxStack[i].amount);
      }
    }
   function getMaxStack() external view returns (address, uint256) {
    uint index=maxStack.length-1;
    require(index < maxStack.length, "Index out of bounds");
    return (maxStack[index]._address, maxStack[index].amount);
}
   function getIsExist() external view returns ( bool) {
    //require(index < maxStack.length, "Index out of bounds");
    return (balances[msg.sender].isExist);
}
    function end() onlyOwner external{
   require(block.timestamp > endingBid, "the Auction is active");
   if(maxStack.length<1){
      NFT_TOKEN.transferFrom( address(this),owner,tokenId);
   }
   else{
      uint amount = maxStack[maxStack.length-1].amount;
      payable(address(owner)).transfer(amount);
      address bidderAddress = maxStack[maxStack.length-1]._address;
      NFT_TOKEN.transferFrom(address(this) ,bidderAddress ,tokenId);
     returnQuotes();
     started= false;
   }
    }

}