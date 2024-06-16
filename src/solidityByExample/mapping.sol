// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Mapping {
    mapping(address => uint256) public myMap;

    function get(address addr) public view returns (uint256) {
        return myMap[addr];
    }

    function set(address addr, uint256 a) public {
        myMap[addr] = a;
    }

    function deleteAddr(address addr) public {
        delete myMap[addr];
    }
}

contract NestedMapping {
    mapping(address => mapping(uint256 => bool)) public myMap;

    function get(address addr, uint256 i) public view returns (bool) {
        return myMap[addr][i];
    }

    function set(address addr, uint256 i) public {
        myMap[addr][i] = true;
    }

    function deleteAddr(address addr, uint256 i) public {
        delete myMap[addr][i];
    }
}
