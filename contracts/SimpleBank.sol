
pragma solidity ^0.5.16;

contract SimpleBank {

    //
    // State variables
    //

    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping (address => uint) private balances;

    /* Fill in the keyword. We want to create a getter function and allow contracts to be able to see if a user is enrolled.  */
    mapping (address => bool) public enrolled;

    /* Let's make sure everyone knows who owns the bank. Use the appropriate keyword for this*/
    address public owner;

    //
    // Events - publicize actions to external listeners
    //

    /* Add an argument for this event, an accountAddress */
    event LogEnrolled(address accountAddress);

    /* Add 2 arguments for this event, an accountAddress and an amount */
    event LogDepositMade(address accountAddress, uint amount);

    /* Create an event called LogWithdrawal */
    /* Add 3 arguments for this event, an accountAddress, withdrawAmount and a newBalance */
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    //
    // Modifiers
    //

    // @notice onlyEnrolled
    // Ensures the msg.sender has already been enrolled before executing a function
    modifier onlyEnrolled {
        require(
            enrolled[msg.sender] == true,
            "Only enrolled accounts can call this function."
        );
        _;
    }

    // @notice notEnrolled
    // Ensures the msg.sender has not already been enrolled before executing a function
    modifier notEnrolled {
        require(
            enrolled[msg.sender] == false,
            "Only accounts not enrolled can call this function."
        );
        _;
    }

    //
    // Functions
    //

    /* Use the appropriate global variable to get the sender of the transaction */
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
    }

    // A SPECIAL KEYWORD prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    // Emit the appropriate event
    function enroll() public notEnrolled returns (bool){ // add modifier so a user cannot enroll more than once
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }


    // Add the appropriate keyword so that this function can receive ether
    // Use the appropriate global variables to get the transaction sender and value
    // Emit the appropriate event
    function deposit() public payable onlyEnrolled returns (uint) { // add modifer to ensure only enrolled users can deposit funds
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, balances[msg.sender]);
        return balances[msg.sender];
    }


    // Emit the appropriate event
    function withdraw(uint withdrawAmount) public returns (uint) {
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw.
           return the user's balance.*/

           //use assert instead of require so we do not return excess ETH for the transaction costs
           // see https://medium.com/blockchannel/the-use-of-revert-assert-and-require-in-solidity-and-the-new-revert-opcode-in-the-evm-1a3a7990e06e
            require(balances[msg.sender] >= withdrawAmount);
            balances[msg.sender] -= withdrawAmount;
            emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
            return balances[msg.sender];
    }

  
}