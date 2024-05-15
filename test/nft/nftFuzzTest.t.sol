pragma solidity ^0.8.0;

import "src/nftAuction/myToken.sol";
import "src/nftAuction/nftAuction.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract NFTAuctionTest is Test {
    NFTAuction public nft;
    MyERC721 public erc721;
    uint256 public endingBid = 200;
    uint256 public startingPrice = 100;
    uint256 public tokenId = 1;
    address public owner = address(123);

    function setUp() public {
        // Deploy NFT and ERC721 contracts for testing
        vm.startPrank(owner);
        nft = new NFTAuction();
        string memory name = "yael";
        string memory symbole = "rachel";
        erc721 = new MyERC721(name, symbole);
        erc721.mint(owner, tokenId);
        erc721.approve(address(nft), tokenId);
    }

    // Test function to check the start of the auction
    function testStartAuction() public {
        nft.start(address(erc721), endingBid, startingPrice, tokenId);
        // Assert the state after calling start
        assertEq(nft.endingBid(), endingBid);
        assertEq(nft.startingPrice(), startingPrice);
        assertEq(nft.tokenId(), tokenId);
        assertEq(nft.started(), true);
        assertEq(erc721.ownerOf(tokenId), address(nft));
    }

    function testAddBiddFuzz(uint8 quoteAmount) public {
        vm.assume(quoteAmount > startingPrice);
        nft.start(address(erc721), endingBid, startingPrice, tokenId);
        console.log("a", quoteAmount);
        address addr = vm.addr(12345);
        vm.startPrank(addr);
        vm.deal(address(addr), 5000);
        nft.addBidd{value: quoteAmount}();
        (address maxStackAddress, uint256 maxStackAmount) = nft.getMaxStack();
        assertEq(maxStackAddress, address(addr), "Unexpected maxStackAddress");
        assertEq(maxStackAmount, quoteAmount, "Unexpected maxStackAmount");
    }

    // Test function to add a quote to the auction

    // Test function to cancel a quote from the auction
    function testCancelBiddFuzz(uint8 quoteAmount) public {
        
        nft.start(address(erc721), endingBid, startingPrice, tokenId);
        vm.assume(quoteAmount > startingPrice);
        address addr = vm.addr(12345);
        vm.startPrank(addr);
        vm.deal(address(addr), 5000);

        nft.addBidd{value: quoteAmount}();
        nft.cancelBidd();
        // Assert the state after canceling the quote
        assert(!nft.getIsExist());
    }

    // Test function to end the auction
    function testEndAuction() public {
        nft.start(address(erc721), endingBid, startingPrice, tokenId);
        address addr = vm.addr(12345);
        vm.startPrank(addr);
        vm.deal(address(addr), 5000);
        uint256 quoteAmount = 150; // Higher than the starting price
        nft.addBidd{value: quoteAmount}();
        vm.warp(124); // Fast forward time to simulate end of auction
        vm.stopPrank();
        vm.startPrank(owner);
        nft.end();
        // Assert the state after ending the auction
        assertEq(nft.started(), false, "Auction is still active after ending");
        assertEq(erc721.ownerOf(tokenId), address(addr), "Unexpected token owner after ending auction");
        assertEq(address(owner).balance, 150, "Incorrect balance after ending auction");
    }
}
