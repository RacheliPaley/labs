pragma solidity ^0.8.0;

import '../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol';

contract NFT {
    address private owner;
    IERC721 public immutable NFT_TOKEN;
    uint private startingBid;
    uint private endingBid;
    uint private startingPrice;
    bool private started;

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

    constructor(address _NFT_TOKEN, uint _startingBid, uint _endingBid, uint _startingPrice) {
        owner = msg.sender;
        NFT_TOKEN = IERC721(_NFT_TOKEN);
        startingBid = _startingBid;
        endingBid = _endingBid;
        startingPrice = _startingPrice;
    }
    function startAuction() public {
        require(msg.sender == owner, "Only the owner can start the auction");
        require(!started, "Auction already started");
        
        NFT_TOKEN.transferFrom(msg.sender, address(this), 1); // העברת ה-NFT מהמוכר לחוזה
        started = true;
        emit Start(); // הפעלת האירוע "Start"
    }
    function addToBalances(address _addr, Object2 memory obj) internal {
        if (balances[_addr].isExist) {
            payable(msg.sender).transfer(balances[_addr].amount);
        }
        balances[_addr] = obj;
    }

   

    function updateMax() internal {
        while (maxStack.length > 0 && !balances[maxStack[maxStack.length - 1]._address].isExist) {
            maxStack.pop();
        }
    }

    function addQuote(address __address, uint256 _amount) public {
        require(block.timestamp > startingBid && block.timestamp < endingBid, "the Auction is closed");
        updateMax();
        require(_amount > maxStack[maxStack.length - 1].amount, "the price is too low");

        Object memory newObj = Object(__address, _amount);
        maxStack.push(newObj);

        Object2 memory newObj2 = Object2(true, _amount);
        addToBalances(__address, newObj2);
    }

    function cancelQuote(address user) public {
        require(block.timestamp > startingBid && block.timestamp < endingBid, "the Auction is closed");
        require(balances[user].isExist, "you are not exist");

        balances[user].isExist = false;
        payable(msg.sender).transfer(balances[user].amount);
    }

    function returnQuotesToPeople() public{
  for (uint i = 0; i < maxStack.length - 1; i++) {
            if(balances[maxStack[i]._address].isExist)
            payable(maxStack[i]._address).transfer(maxStack[i].amount);
        }
    }

   function finishAuction() public {
    require(block.timestamp > endingBid, "the Auction is active");
    updateMax();

    if (maxStack.length > 0) {
        address winner = maxStack[maxStack.length - 1]._address;
        uint winningAmount = maxStack[maxStack.length - 1].amount;
        NFT_TOKEN.transferFrom(address(this), winner, 1);
        payable(owner).transfer(winningAmount);
returnQuotesToPeople();
      
    } else {
      
      returnQuotesToPeople();
    }
}

    receive() external payable {
        addQuote(msg.sender, msg.value);
    }
      event Start();
}
