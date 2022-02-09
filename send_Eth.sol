// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.1;


contract Owner{

    address internal owner;
    modifier OnlyOwner(){
        require(owner==msg.sender);
        _;
    }
    function getOwner()public view returns(address){
        return owner;
    }

    function setOwner(address _newOwner) OnlyOwner() public {
        owner= _newOwner;
    }

    

}


// NOTE: Deploy this contract first
contract MainContract is Owner {
    address addressContract= address(this);

    struct userAmount{
        uint amount;
    }
    mapping(address=> userAmount) internal user;

    constructor() {
         owner= msg.sender;
    }
    event Deposit(uint256);
    function deposit(uint256 _amount) public payable{
        require(_amount==msg.value);
        user[msg.sender]= userAmount(_amount);
        emit Deposit(msg.value);
    }

    event TransferETH(bool,bytes);
    function transferEth(address _container, uint256 _amount) public OnlyOwner(){
        require(user[msg.sender].amount>0);
        user[msg.sender].amount=0;
        (bool sent, bytes memory data) = payable(_container).call{value: _amount, gas:100000}("");
        require(sent, "Failed to send Ether");
        emit TransferETH(sent,data);
    }

    function getAmountUser(address _ser) public view returns(uint256){
        return user[_ser].amount;
    }

}
