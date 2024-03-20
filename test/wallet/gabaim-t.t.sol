pragma solidity ^0.8.20;

import "@hack/wallet/gabaim.sol";
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract Payer {
}

contract Receiver {
}

contract GabaimTest is Test {
    Gabaim public wallet;
    Payer public payer;
    Receiver public receiver;

    /// @dev Setup the testing environment.
    function setUp() public {
        wallet = new Gabaim();
        payer = new Payer();
        receiver = new Receiver();

        // Initialize the contracts with initial balance
        // Send initial balance to the wallet contract
        payable(address(wallet)).transfer(1000); // Sending 1000 wei to the wallet
        // You can similarly initialize payer and receiver contracts if needed
    }

    function testDeposit() public {
        uint256 initialBalance = address(wallet).balance;
        uint256 depositAmount = 100;

        // Send Ether to the contract
        payable(address(wallet)).transfer(depositAmount);

        // Check balance after deposit
        uint256 expectedBalance = initialBalance + depositAmount;
        uint256 currentBalance = address(wallet).balance;

        assertEq(currentBalance, expectedBalance, "Deposit amount was not added correctly to the balance");
    }

    function testWithdraw() public {
        uint256 initialBalance = address(wallet).balance;
        uint256 withdrawAmount = 100;

        // Withdraw
        wallet.withdraw(withdrawAmount);

        // Check balance after withdrawal
        uint256 expectedBalance = initialBalance - withdrawAmount;
        uint256 currentBalance = address(wallet).balance;

        assertEq(currentBalance, expectedBalance, "Withdrawal amount was not subtracted correctly from the balance");
    }
}
