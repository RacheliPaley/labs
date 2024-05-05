// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract amm{
address owner;
ERC20 balanceA = 0;
ERC20 balanceB = 0;
uint K = balanceA * balanceB;

constructor(){

    owner = msg.sender;

    balanceA.approve(1000);
    balanceA.mint(1000);
    balanceB.approve(1000);
    balanceB.mint(1000);
}

price(){

}




}
