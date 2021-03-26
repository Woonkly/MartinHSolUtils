// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/GSN/Context.sol";

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


contract OwnersLMH is Context{

 using SafeMath for uint256;

//Section Type declarations
    struct Sowners {
    address account;
    uint8 flag; //0 no exist  1 exist 2 deleted
    
  }

//Section State variables
  uint256 internal _lastIndexSowners;
  mapping(uint256 => Sowners) internal _Sowners;    
  mapping(address => uint256) internal _IDSownersIndex;    
  uint256 internal _SownersCount;


//Section Modifier
      modifier onlyNewOwners(address account) {
        require(!this.OwnerExist(account), "1");
        _;
      }
      
      
      modifier onlyOwnersExist(address account) {
        require(this.OwnerExist(account), "1");
        _;
      }
      
      modifier onlySownersIndexExist(uint256 index) {
        require(SownersIndexExist(index), "1");
        _;
      }
  
  
      modifier onlyIsInOwners() {
        require(OwnerExist( _msgSender()) , "1");
        _;
    }





//Section Events
event addNewInOwners(address account);
event RemovedFromOwners(address account);


 

constructor () internal {
      _lastIndexSowners = 0;
       _SownersCount = 0;
       
       address msgSender = _msgSender();
       addOwner( msgSender);
    }    



    function getOwnersCount() public view returns (uint256) {
        return _SownersCount;
    }


    function OwnerExist(address account) public view returns (bool) {
        return _SownersExist( _IDSownersIndex[account]);
    }

    function SownersIndexExist(uint256 index) internal view returns (bool) {
       
        return (index <  (_lastIndexSowners + 1) );
    }


    function _SownersExist(uint256 SownersID)internal view returns (bool) {
        return (_Sowners[SownersID].flag == 1 );         
    }
  

function addOwner(address account) private returns(uint256){
    _lastIndexSowners=_lastIndexSowners.add(1);
    _SownersCount=  _SownersCount.add(1);
    
    _Sowners[_lastIndexSowners].account = account;
      _Sowners[_lastIndexSowners].flag = 1;
    
    _IDSownersIndex[account] = _lastIndexSowners;
    
    emit addNewInOwners(account);
    return _lastIndexSowners;
}   
     
 function newInOwners(address account ) external onlyIsInOwners onlyNewOwners(account)  returns (uint256){
     return addOwner( account);
}    



function removeFromOwners(address account) external onlyIsInOwners onlyOwnersExist(account) {
    _Sowners[ _IDSownersIndex[account] ].flag = 2;
    _Sowners[ _IDSownersIndex[account] ].account=address(0);
    _SownersCount=  _SownersCount.sub(1);
    emit RemovedFromOwners( account);
}






function getOwnerByIndex(uint256 index) public view  returns( address) {
    
        if(!SownersIndexExist( index)) return address(0);
     
        Sowners memory p= _Sowners[ index ];
         
        return ( p.account);
    }



function getAllOwners() public view returns(uint256[] memory, address[] memory ) {
  
    uint256[] memory indexs=new uint256[](_SownersCount);
    address[] memory pACCs=new address[](_SownersCount);
    

    uint256 ind=0;
    
    for (uint32 i = 0; i < (_lastIndexSowners +1) ; i++) {
        Sowners memory p= _Sowners[ i ];
        if(p.flag == 1 ){
            indexs[ind]=i;
            pACCs[ind]=p.account;
            ind++;
        }
    }

    return (indexs, pACCs);

}



    
}