// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "src/NFT/nft.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract TestNFT is Test {

    NFT nft;
    IERC721 _nftToken;

    function setUp() public {
        nft = new NFT(address(this), 100, 2000, 50); // יצירת חוזה חכם חדש עבור כל בדיקה
        _nftToken = IERC721(address(nft));
    }

    function testStartAuction() public {
        console.log("fff");
        nft.startAuction();
        assertTrue(nft.started(), "Auction should have started");
    }

    // function testAddQuote() public {
    //     nft.startAuction();
    //     nft.addQuote(address(this), 120);
    //      assertEq(nft.maxStackLength(), 1, "Max stack length should be 1 after adding a quote");
    // }

    // function testCancelQuote() public {
    //     nft.startAuction();
    //     nft.addQuote(address(this), 120);
    //     nft.cancelQuote(address(this));
    //      assertEq(nft.balances(address(this)), 0, "Balance should be 0 after canceling quote");
    // }

    // function testFinishAuction() public {
    //     nft.startAuction();
    //     nft.addQuote(address(this), 120);
    //     nft.finishAuction();
    //       assertEq(_nftToken.ownerOf(1), address(this), "Contract should become owner of the NFT after auction finishes");
    // }

    // function testSafety() public {
    //     nft.startAuction();
    //     nft.addQuote(address(this), 120);
    //     nft.addQuote(address(0x01), 150);
    //     nft.addQuote(address(this), 140);
    //       assertEq(nft.maxStackAmount(), 150, "Max stack amount should be 150");
    // }


}
