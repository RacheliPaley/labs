// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Functions {
    function f() public view returns (uint256, bool, uint256) {
        return (5, false, 7);
    }

    function f1() public view returns (uint256 x, uint256 y, uint256 z) {
        return (5, 2, 7);
    }

    function f2() public view returns (uint256 x, uint256 y) {
        x = 5;
        y = 3;
    }

    function f3() public view returns (uint256 x, uint256 y, uint256 z, uint256 w, uint256 r) {
        (uint256 x, uint256 y, uint256 z) = f1();
        (uint256 w, uint256 r) = f2();
        return (x, y, z, w, r);
    }

    function f4(uint[] memory  arr) public{

    }
}
