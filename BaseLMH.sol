// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "https://github.com/Woonkly/OpenZeppelinBaseContracts/contracts/token/ERC20/ERC20.sol";

contract BaseLMH {

    event CoinReceived(uint256 coins);
    
    receive() external payable virtual {
            // React to receiving ether

            
        emit CoinReceived(msg.value);
    }


    fallback()  external payable virtual{

        
    }


    function getMyCoinBalance() public view returns(uint256){
            address payable self = address(this);
            uint256 bal =  self.balance;    
            return bal;
    }

    function getMyTokensBalance(address sc) public view returns(uint256){
        IERC20 _token = IERC20(sc);
        return _token.balanceOf(address(this));
    }


    function getTokensBalanceOf(address sc,address account)public view returns(uint256){
        IERC20 _token = IERC20(sc);
        return _token.balanceOf(account);
    }


    modifier IhaveEnoughTokens(address sc,uint256 token_amount) {
        uint256 amount=getMyTokensBalance(sc);
        require( token_amount <= amount ,"-tk" );
        _;
    }
  
  
    modifier IhaveEnoughCoins(uint256 coins) {
        uint256 amount=getMyCoinBalance();
        require( coins <= amount ,"-coin" );
        _;
    }


    modifier hasApprovedTokens(address sc,address sender, uint256 token_amount) {
        IERC20 _token = IERC20(sc);
        require(  _token.allowance(sender,address(this)) >= token_amount , "!aptk"); 
        _;
    }

}