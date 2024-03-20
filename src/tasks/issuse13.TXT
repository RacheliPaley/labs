
PUSH1 0x2   //[2]
PUSH2 0x3   //[ 3,2]
PUSH2 0x4  //[4, 3,2]
ADD       // [7,2]
PUSH1 0x1  // [1,7,2]
 
MUL  //[7,2]
POP   //[2]
PUSH1 0x1  // [1,,2]
LT    // [1]

