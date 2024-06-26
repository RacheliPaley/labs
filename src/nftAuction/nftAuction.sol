pragma solidity ^0.8.0;

import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "./myToken.sol";
import "forge-std/console.sol";

contract NFTAuction {
    address private owner;
    MyERC721 public nftToken;
    uint256 public startingBid;
    uint256 public endingBid;
    uint256 public startingPrice;
    uint256 public tokenId;
    bool public started;

    struct Bidder {
        address _address;
        uint256 amount;
    }

    struct BidState {
        bool isExist;
        uint256 amount;
    }

    // bidder balances
    mapping(address => BidState) public balances;
    Bidder[] public maxStack;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function start(address _nftToken, uint256 _endingBid, uint256 _startingPrice, uint256 _tokenId)
        external
        onlyOwner
    {
        nftToken = MyERC721(_nftToken);
        endingBid = _endingBid;
        startingPrice = _startingPrice;
        tokenId = _tokenId;
        nftToken.transferFrom(owner, address(this), tokenId);
        started = true;
        console.log("start", started);
    }

    function addToBalances(address _addr, BidState memory obj) internal {
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

    function addBidd() public payable {
        console.log("user", msg.sender, "amount", msg.value);
        console.log(started);
        console.log(block.timestamp, "   ", endingBid);

        require(started && block.timestamp < endingBid, "the Auction is closed");

        updateMax();
        if (maxStack.length > 1) {
            console.log("zzz");
            require(msg.value > maxStack[maxStack.length - 1].amount && msg.value > 0, "the price is too low");
        } else {
            require(msg.value > startingPrice && msg.value > 0, "the price is too low");
        }

        Bidder memory newObj = Bidder(address(msg.sender), msg.value);
        maxStack.push(newObj);
        BidState memory newObj2 = BidState(true, msg.value);

        addToBalances(address(msg.sender), newObj2);
        console.log("userrr", msg.sender, "amount", msg.value);
    }

    function cancelBidd() public {
        require(started && block.timestamp < endingBid, "the Auction is closed");
        require(balances[address(msg.sender)].isExist, "you are not exist");
        balances[address(msg.sender)].isExist = false;
        payable(msg.sender).transfer(balances[address(msg.sender)].amount);
    }

    function returnBidd() public {
        require(block.timestamp > endingBid, "the Auction is active");
        updateMax();
        for (uint256 i = 0; i < maxStack.length - 1; i++) {
            payable(address(maxStack[i]._address)).transfer(maxStack[i].amount);
        }
    }

    function getMaxStack() external view returns (address, uint256) {
        uint256 index = maxStack.length - 1;
        require(index < maxStack.length, "Index out of bounds");
        return (maxStack[index]._address, maxStack[index].amount);
    }

    function getIsExist() external view returns (bool) {
        //require(index < maxStack.length, "Index out of bounds");
        return (balances[msg.sender].isExist);
    }

    function end() external onlyOwner {
        require(block.timestamp > endingBid, "the Auction is active");
        if (maxStack.length < 1) {
            nftToken.transferFrom(address(this), owner, tokenId);
        } else {
            uint256 amount = maxStack[maxStack.length - 1].amount;
            payable(address(owner)).transfer(amount);
            address bidderAddress = maxStack[maxStack.length - 1]._address;
            nftToken.transferFrom(address(this), bidderAddress, tokenId);
            // returnBidd();
            started = false;
        }
    }
}
