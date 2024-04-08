// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Reward_4_7 is ERC20 {
    address public owner;
    uint private REWARD_AMOUNT = 1000000; // 1 million reward tokens
    uint private constant SEVEN_DAYS_IN_SECONDS = 7 days;
    uint private TOTAL_DEPOSITS = 0;

    struct Deposit {
        uint amount;
        uint timestamp;
    }

    // User address => deposit index => deposit information
    mapping(address => mapping(uint => Deposit)) public deposits;
    // Mapping to store the number of deposits per user
    mapping(address => uint) public depositCounts;

    constructor() ERC20("Reward_4_7", "RWD_4_7") {
        owner = msg.sender;
        _mint(msg.sender, REWARD_AMOUNT);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function deposit(uint _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        ERC20._transfer(msg.sender, address(this), _amount);

        uint depositIndex = depositCounts[msg.sender];
        deposits[msg.sender][depositIndex] = Deposit(_amount, block.timestamp);
        depositCounts[msg.sender]++;

        TOTAL_DEPOSITS += _amount;
    }

    function calc_rewards(uint _amount) public view returns (string memory) {
        uint reward = (_amount * REWARD_AMOUNT) / TOTAL_DEPOSITS;
        uint rewardInWAD = reward / (10 ** uint256(decimals()));
        uint remainder = reward % (10 ** uint256(decimals()));

        // Convert rewardInWAD and remainder to strings using Strings library
        string memory rewardStr = Strings.toString(rewardInWAD);
        string memory remainderStr = Strings.toString(remainder);

        // Concatenate the strings
        string memory result = string(
            abi.encodePacked(rewardStr, ".", remainderStr)
        );

        return result;
    }

    function updateWithdrawalAmount(uint _withdrawalAmount) external {
        uint latestDate = block.timestamp - SEVEN_DAYS_IN_SECONDS;
        uint totalWithdrawn = 0;

        // Iterate over deposits for the current user
        for (uint i = 0; i < depositCounts[msg.sender]; i++) {
            // Check if the deposit date is more than 7 days ago
            if (deposits[msg.sender][i].timestamp < latestDate) {
                // Check if the withdrawal amount is less than or equal to the amount available for withdrawal
                if (
                    _withdrawalAmount <=
                    deposits[msg.sender][i].amount - totalWithdrawn
                ) {
                    // Update the withdrawal amount and exit the loop
                    deposits[msg.sender][i].amount -= _withdrawalAmount;

                    calc_rewards(_withdrawalAmount);
                    TOTAL_DEPOSITS -= _withdrawalAmount;
                    return;
                } else {
                    // Update the total withdrawn amount and set the deposit amount to 0
                    totalWithdrawn += deposits[msg.sender][i].amount;
                    deposits[msg.sender][i].amount = 0;
                }
            }
        }

        // Revert if there isn't enough balance available for withdrawal
        require(
            _withdrawalAmount <= totalWithdrawn,
            "Insufficient balance for withdrawal"
        );
        calc_rewards(_withdrawalAmount);
        TOTAL_DEPOSITS -= _withdrawalAmount;
    }

    function withdrawWithoutReward(uint _amount) external onlyOwner {
        ERC20._transfer(address(this), msg.sender, _amount);
    }

    function getBalanceWithReward(address _account) public view returns (uint) {
        uint sum;
        uint latestDate = block.timestamp - SEVEN_DAYS_IN_SECONDS;

        // Iterate over deposits for the given account
        for (
            uint i = 0;
            i < depositCounts[_account] &&
                deposits[_account][i].timestamp >= latestDate;
            i++
        ) {
            sum += deposits[_account][i].amount;
        }
        return sum;
    }

    function getTotalBalance(address _account) public view returns (uint) {
        uint totalBalance;

        // Iterate over all deposits for the specified account
        for (uint i = 0; i < depositCounts[_account]; i++) {
            totalBalance += deposits[_account][i].amount;
        }
        return totalBalance;
    }

    function getEstimatedRewards(
        uint _amount
    ) external view returns (string memory) {
        return calc_rewards(_amount);
    }
}
