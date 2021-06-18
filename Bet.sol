// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Bet{
    
    struct BetPlayer{
        address _payer;
        uint _money;
        uint _option;
        uint _prize;
        uint _stsatus;
    }
    
    BetPlayer[] private ListPayments;
    address private owner;
    uint private Prize;
    uint private Money_Win;
    uint public CHECK;
    
    constructor(){
        owner = msg.sender;
        Prize = 0;
        Money_Win = 0;
    }
    
    function getBalance()  public view returns(uint){
        return address(this).balance;
    }
    
    function betMoney(uint Option) public payable{
        BetPlayer memory newBet = BetPlayer(msg.sender, msg.value, Option, 0, 0);
        ListPayments.push(newBet);
    }
    
    function counting() public view returns(uint){
        return ListPayments.length;
    }
    
    function get_1_Payment(uint ordering) public view returns(address, uint, uint, uint, uint){
        return (ListPayments[ordering]._payer, ListPayments[ordering]._money, ListPayments[ordering]._option, ListPayments[ordering]._prize, ListPayments[ordering]._stsatus);
    }
    
    function processResult(uint result) public {
        CHECK = 0;
        if(msg.sender == owner){
            if(result==1){
                
                for (uint i=0; i<ListPayments.length; i++) {
                    if(ListPayments[i]._option==0){
                        Prize = Prize +  ListPayments[i]._money;
                    }
                    if(ListPayments[i]._option==1){
                        Money_Win = Money_Win +  ListPayments[i]._money;
                    }
                }
                
                CHECK = Prize;
                
                for (uint i=0; i<ListPayments.length; i++) {
                    if(ListPayments[i]._option==1){
                        ListPayments[i]._prize = ListPayments[i]._money/Money_Win*Prize/100;
                        address payable receiver = payable(ListPayments[i]._payer);
                        transferPrize(receiver, ListPayments[i]._money/Money_Win*Prize/100/2);
                    }
                }

            }else{
                
                for (uint i=0; i<ListPayments.length; i++) {
                    if(ListPayments[i]._option==1){
                        Prize = Prize +  ListPayments[i]._money;
                    }
                }
                CHECK = Prize;
         
            }
        }else{
            CHECK = 999999;
        }
        
    }
    
    function transferPrize(address payable to, uint value) private{
        to.transfer(value);
    }
    
}


