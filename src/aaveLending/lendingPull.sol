// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./interfaces/ISwapRouter.sol";
import "./math.sol";
import "./MyERC20.sol"; // Import your MyERC20 contract
import "./aaveLibrary.sol"; // Import the AaveLibrary

interface IUniswapRouter is ISwapRouter {
    function refundETH() external payable;
}

contract BondToken is Ownable, Math {
    using SafeMath for uint256;
    using AaveLibrary for ILendingPool;
    using AaveLibrary for IWETHGateway;

    uint256 public totalBorrowed;
    uint256 public totalReserve;
    uint256 public totalDeposit;
    uint256 public maxLTV = 4; // 1 = 20%
    uint256 public ethTreasury;
    uint256 public totalCollateral;
    uint256 public baseRate = 20000000000000000;
    uint256 public fixedAnnuBorrowRate = 300000000000000000;

    ILendingPool public constant aave =
        ILendingPool(0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe);
    IWETHGateway public constant wethGateway =
        IWETHGateway(0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70);
    IERC20 public constant dai =
        IERC20(0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD);
    IERC20 public constant aDai =
        IERC20(0xdCf0aF9e59C002FA3AA091a46196b37530FD48a8);
    IERC20 public constant aWeth =
        IERC20(0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347);
    AggregatorV3Interface internal constant priceFeed =
        AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    IUniswapRouter public constant uniswapRouter =
        IUniswapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    IERC20 private constant weth =
        IERC20(0xd0A1E359811322d97991E03f863a0C30C2cF029C);

    MyERC20 public bondToken; // Declare the MyERC20 instance

    mapping(address => uint256) private usersCollateral;
    mapping(address => uint256) private usersBorrowed;

    constructor(address _bondTokenAddress) {
        bondToken = MyERC20(_bondTokenAddress); // Initialize the MyERC20 instance
    }

    function bondAsset(uint256 _amount) external {
        dai.transferFrom(msg.sender, address(this), _amount);
        totalDeposit += _amount;
        aave.depositToAave(dai, _amount, address(this));
        uint256 bondsToMint = getExp(_amount, getExchangeRate());
        bondToken.mint(msg.sender, bondsToMint);
    }

    function unbondAsset(uint256 _amount) external {
        require(_amount <= bondToken.balanceOf(msg.sender), "Not enough bonds!");
        uint256 daiToReceive = mulExp(_amount, getExchangeRate());
        totalDeposit -= daiToReceive;
        bondToken.burn(msg.sender, _amount);
        aave.withdrawFromAave(dai, daiToReceive, msg.sender);
    }

    function addCollateral() external payable {
        require(msg.value != 0, "Cant send 0 ethers");
        usersCollateral[msg.sender] += msg.value;
        totalCollateral += msg.value;
        wethGateway.depositWethToAave(address(aave), msg.value, address(this));
    }

    function removeCollateral(uint256 _amount) external {
        uint256 wethPrice = uint256(_getLatestPrice());
        uint256 collateral = usersCollateral[msg.sender];
        require(collateral > 0, "Dont have any collateral");
        uint256 borrowed = usersBorrowed[msg.sender];
        uint256 amountLeft = mulExp(collateral, wethPrice).sub(borrowed);
        uint256 amountToRemove = mulExp(_amount, wethPrice);
        require(amountToRemove < amountLeft, "Not enough collateral to remove");
        usersCollateral[msg.sender] -= _amount;
        totalCollateral -= _amount;
        wethGateway.withdrawWethFromAave(address(aave), _amount, address(this));
        payable(msg.sender).transfer(_amount);
    }

    function borrow(uint256 _amount) external {
        require(_amount <= _borrowLimit(), "No collateral enough");
        usersBorrowed[msg.sender] += _amount;
        totalBorrowed += _amount;
        aave.withdrawFromAave(dai, _amount, msg.sender);
    }

    function repay(uint256 _amount) external {
        require(usersBorrowed[msg.sender] > 0, "Doesnt have a debt to pay");
        dai.transferFrom(msg.sender, address(this), _amount);
        (uint256 fee, uint256 paid) = calculateBorrowFee(_amount);
        usersBorrowed[msg.sender] -= paid;
        totalBorrowed -= paid;
        totalReserve += fee;
        aave.depositToAave(dai, _amount, address(this));
    }

    // Remaining functions here ...

    function _getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price * 10**10;
    }

    // Remaining internal utility functions here ...
}
