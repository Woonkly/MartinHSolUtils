// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/ERC20.sol";

/**
MIT License
Copyright (c) 2021 Woonkly OU
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED BY WOONKLY OU "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

contract BaseLMH {
    //Section Type declarations

    //Section State variables

    //Section Modifier
    modifier IhaveEnoughTokens(address sc, uint256 token_amount) {
        require(token_amount <= getMyTokensBalance(sc), "1");
        _;
    }

    modifier IhaveEnoughCoins(uint256 coins) {
        require(coins <= getMyCoinBalance(), "1");
        _;
    }

    modifier hasApprovedTokens(
        address sc,
        address sender,
        uint256 token_amount
    ) {
        IERC20 _token = IERC20(sc);
        require(_token.allowance(sender, address(this)) >= token_amount, "1");
        _;
    }

    //Section Events
    event CoinReceived(uint256 coins);

    //Section functions

    receive() external payable virtual {
        emit CoinReceived(msg.value);
    }

    fallback() external payable {}

    function getMyCoinBalance() public virtual view returns (uint256) {
        address payable self = address(this);
        uint256 bal = self.balance;
        return bal;
    }

    function getMyTokensBalance(address sc) public view returns (uint256) {
        IERC20 _token = IERC20(sc);
        return _token.balanceOf(address(this));
    }

    function getTokensBalanceOf(address sc, address account)
        public
        view
        returns (uint256)
    {
        IERC20 _token = IERC20(sc);
        return _token.balanceOf(account);
    }
}
