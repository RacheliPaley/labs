// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Reward_4_7 is ERC20 {
    address public owner;
    uint private  REWARD_AMOUNT = 1000000; // 1 million reward tokens
    uint private constant SEVEN_DAYS_IN_SECONDS = 7 days;
    uint private TOTAL_DEPOSITS = 0;

    // User address => deposit information => date => amount
    mapping(address => mapping(uint => uint)) public deposits;

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
      transferFrom(msg.sender, address(this), _amount);
        deposits[msg.sender][block.timestamp] = _amount;
        TOTAL_DEPOSITS += _amount;
    }

    function calc_rewards(uint _amount) public view returns (uint ) {
        uint reward = (_amount * REWARD_AMOUNT) / TOTAL_DEPOSITS;
        // uint rewardInWAD = reward / (10 ** uint256(decimals()));
        // uint remainder = reward % (10 ** uint256(decimals()));

        // Convert rewardInWAD and remainder to strings using Strings library
        // string memory rewardStr = Strings.toString(rewardInWAD);
        // string memory remainderStr = Strings.toString(remainder);

        // // Concatenate the strings
        // string memory result = string(abi.encodePacked(rewardStr, ".", remainderStr));

        return reward;
    }

    function withdrawWithReward(uint _amount) external {
        require(_amount > 0, "amount = 0");
        uint BalnceWithReward = getBalanceWithReward(msg.sender);
        require(BalnceWithReward >= _amount, "insufficient available amount for withdrawal with rewards");
        uint reward=calc_rewards(_amount);
        transferFrom(address(this),msg.sender, _amount+reward);
        TOTAL_DEPOSITS-=_amount;
        REWARD_AMOUNT -=reward;
        uint  countZero=0;
        for (uint i = 0; i < deposits[msg.sender].length && _amount>0; i++) {
        uint  tempAmount=deposits[msg.sender][i];
            if(tempAmount<_amount){
            _amount-=tempAmount;
            deposits[msg.sender][i]=0;
            countZero++;
            }
            else{
                deposits[msg.sender][i]-=tempAmount;
                _amount=0;
            }
            }
             for (uint j = countZero; j < deposits[msg.sender].length - 1; j++) {
                    deposits[msg.sender][j-countZero] = deposits[msg.sender][j];
                }
                for (uint j = 0; j < countZero; j++) {
                    deposits[msg.sender].pop();
                }
    }
   

    function getBalanceWithReward(address _account) public view returns (uint) {
        uint sum;
        uint latestDate = block.timestamp - SEVEN_DAYS_IN_SECONDS;

        // Iterate over deposits for the given account
        for (uint i = 0; i < deposits[_account][block.timestamp]; i++) {
            // Check if the deposit date is at least 7 days ago
            if (i < latestDate) {
                sum += deposits[_account][i];
            } else {
                // If the date is less than seven days ago, exit the loop
                break;
            }
        }
        return sum;
    }

    function getTotalBalance(address _account) public view returns (uint) {
        uint totalBalance;

        // Iterate over all timestamps in the deposits mapping for the specified account
        // and sum up all the deposit amounts
        for (uint i = 0; i < deposits[_account][block.timestamp]; i++) {
            totalBalance += deposits[_account][i];
        }
        return totalBalance;
    }

    function getEstimatedRewards(uint _amount) external view returns (string memory) {
        return calc_rewards(_amount);
    }
}
