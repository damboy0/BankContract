// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

contract BankContract {

    struct Account {
        string name;
        string email;
        uint256 balance;
    }

    mapping(address => Account) public accounts;  

    event CreatedAccount(address indexed user, string name);
    event Deposit(address indexed user, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    function createAccount(string memory _name, string memory _email) public {
        accounts[msg.sender] = Account({
            name: _name,
            email: _email,
            balance: 0
        });

        emit CreatedAccount(msg.sender, _name);
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        
        accounts[msg.sender].balance += msg.value; 
        emit Deposit(msg.sender, msg.value);
    }

    function transfer(address payable _to, uint256 _amount) public {
        require(accounts[msg.sender].balance >= _amount, "Insufficient balance");
        require(_amount > 0, "amount must be greater than zero");

        accounts[msg.sender].balance -= _amount; 
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Ether not sent");

        emit Transfer(msg.sender, _to, _amount);
    }

    function withdraw(uint256 _amount) public {
        require(accounts[msg.sender].balance >= _amount, "Insufficient balance");
        require(_amount > 0, "amount must be greater than zero");

        accounts[msg.sender].balance -= _amount;  
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        emit Withdraw(msg.sender, _amount);
    }

}
