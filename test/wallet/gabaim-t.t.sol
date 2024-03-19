pragma solidity ^0.8.20;

import "@hack/wallet/gabaim.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";


contract GabaimTest is Test {
 
    gabaim public wallet;

    /// @dev Setup the testing environment.
    function setUp() public {
        wallet = new gabaim();
     
    }

 function testDeposit() public {
    uint initialBalance = address(wallet).balance;
    uint depositAmount = 100;

    // Send Ether to the contract
    payable(address(wallet)).transfer(depositAmount);

    // Check balance after deposit
    uint expectedBalance = initialBalance + depositAmount;
    uint currentBalance = address(wallet).balance;

   assertEq(currentBalance, expectedBalance, "Deposit amount was not added correctly to the balance");
}
    function testWithdraw() public {
        uint initialBalance = address(wallet).balance;
        uint withdrawAmount = 100;

        // Withdraw
        wallet.withdraw(withdrawAmount);

        // Check balance after withdrawal
        uint expectedBalance = initialBalance - withdrawAmount;
        uint currentBalance = address(wallet).balance;

       assertEq(currentBalance, expectedBalance, "Withdrawal amount was not subtracted correctly from the balance");
    }
}