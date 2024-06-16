// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;


contract For_Loop{



    function foo() public{

   for(uint i = 0; i<10 ; i++){

    if (i == 3) {
        i++;
        continue;
     if(i ==6)
      break;   
    }


   }

   uint j=10;
   while(j>0){
    j--;
   }

    }
}