
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol"; // Assuming you're using Foundry/Hardhat for testing
// Importing your token contract
import "src/AMM/cp.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/console.sol";
contract SwapTest is Test {
    CP public amm; // Your AMM contract
    MyToken public token0;
    MyToken public token1;
    address user1;
    address user2;
    uint constant INITIAL_RESERVE0 = 1000;
    uint constant INITIAL_RESERVE1 = 2000;
    function setUp() public {
        // Deploy tokens
        token0 = new MyToken(); // Token with initial supply of 10,000
        token1 = new MyToken();
        // Deploy AMM contract
        amm = new CP(address(token0), address(token1));
        console.log("amm", address(amm));
    }
    function testSwap() public {
        token0.mint(2000);
        // console.log(token0.balance);
    }
    function testValidSwap() public {
    uint swapAmount = 100;
    // Mint tokens for user1
    user1 = address(0x123); // Set up user1 address
    console.log("user1", address(user1));
    // Approve the contract to spend the required tokens
    vm.startPrank(user1);
    vm.deal(address(user1), 2000);
    console.log("vm.deal",address(user1).balance);
    token0.approve(address(amm), 20000); // Ensure approval to the correct contract
    token0.mint(2000);
    // Get initial reserves
    uint reserve0Before = amm.reserve0();
    uint reserve1Before = amm.reserve1();
    console.log("Initial reserves", reserve0Before, reserve1Before); // Log initial reserves
    uint amountOut = amm.swap(address(token0), swapAmount);
    // Calculate expected output after the swap
    uint expectedOut = (reserve1Before * ((swapAmount * 997) / 1000)) /
                       (reserve0Before + ((swapAmount * 997) / 1000));
    // Ensure the returned amountOut matches the expected value
    assertEq(amountOut, expectedOut, "Returned amountOut doesn't match expected value");
    // Verify the reserves have updated correctly after the swap
    assertEq(amm.reserve0(), reserve0Before + swapAmount, "Reserve0 not updated correctly");
    assertEq(amm.reserve1(), reserve1Before - amountOut, "Reserve1 not updated correctly");
    console.log("Reserves after swap", amm.reserve0(), amm.reserve1()); // Log updated reserves
}
    function testInvalidToken() public {
        // Trying to swap a token that's not in the pool should fail
        MyToken invalidToken = new MyToken();
        vm.expectRevert("AMM3-invalid-token");
        amm.swap(address(invalidToken), 100);
    }
    function testZeroAmount() public {
        token0.mint(2000);
        // Trying to swap zero amount should fail
        vm.expectRevert("AMM3-zero-amount");
        amm.swap(address(token0), 0);
    }

    function addLiquidity() public {
        
    }
}