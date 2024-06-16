// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Primitives {
    uint8 public a = 7;
    uint16 public b = 14;
    uint256 public c = 189;
    int8 public d = -5;
    int256 public e = -148;
    bool public boo = false;
    uint256 public maxInt2 = type(uint256).max;
    uint256 public minInt2 = type(uint256).min;
    address public addr = address(1234);

    bytes1 a1 = 0x55; //  [01010101]
    bytes1 b1 = 0x56; // [01010110]
}
