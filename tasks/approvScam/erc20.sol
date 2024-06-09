// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract ContractTest is Test {
    ERC20 ERC20Contract;
    address alice = vm.addr(1);
    address eve = vm.addr(2);

    function testApproveScam() public {
        ERC20Contract = new ERC20();
        ERC20Contract.mint(1000);
        ERC20Contract.transfer(address(alice), 1000);

        vm.prank(alice);
        // Be Careful to grant unlimited amount to unknown website/address.
        // Do not perform approve, if you are sure it's from a legitimate website.
        // Alice granted approval permission to Eve.
        ERC20Contract.approve(address(eve), type(uint256).max);

        console.log(
            "Before exploiting, Balance of Eve:",
            ERC20Contract.balanceOf(eve)
        );
        console.log(
            "Due to Alice granted transfer permission to Eve, now Eve can move funds from Alice"
        );
        vm.prank(eve);
        // Now, Eve can move funds from Alice.
        ERC20Contract.transferFrom(address(alice), address(eve), 1000);
        console.log(
            "After exploiting, Balance of Eve:",
            ERC20Contract.balanceOf(eve)
        );
        console.log("Exploit completed");
    }

    receive() external payable {}
}

interface IERC20 {

  function totalSupply() external view returns (uint);

  function balanceOf(address spender) external view returns (uint);

  function transfer(address to ,  uint amount)  external view returns (bool);
   
  function transferFrom(address to , address from ,   uint amount)  external view returns (bool);

  function approve(address spender, uint amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}
  contract ERC20 is IERC20 {

    uint public totalSupply;
    mapping (address=>uint) public balanceOf;
    mapping (address=>mapping (address=>uint)) public allowance;
    string public name ="test";
    string public symbol ="";
    uint public decimals = 18;
    function transfer(address to , uint amount){

       balanceOf[msg.sender] -=amount;
       balanceOf[to] +=amount;
       emit Transfer(msg.sender, to , amount);

    }

    function approve(address spender , uint amount) external returns(bool){
        allowance[msg.sender][spender] +=amount;
        emit Approval(msg.sender, spender , amount);

      }

     function transferFrom(address sender , address recipient, uint amount)  external returns(bool) { 

        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -=amount;
        balanceOf[recipient] +=amount;
        emit Transfer(sender, recipient , amount);

     }

    function mint(uint amount) external {

     balanceOf[msg.sender] +=amount;
     totalSuppy += amount;
     emit Transfer(address(0), msg.sender , amount);
          
    }
    function burn(uint amount) external {

     balanceOf[msg.sender] -=amount;
     totalSuppy -= amount;
     emit Transfer(msg.sender  , address(0), amount);
          
    }












  }









}