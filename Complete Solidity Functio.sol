pragma solidity >=0.6.0 <0.8.0;

contract Math{

    function isMultiple(uint8 _n, uint8 _m) public pure returns(bool) {
        
        if(_n % _m == 0 ){
               return true;
        }
          else{
              return false;
          }
    }
    
    function max(uint256 _n, uint256 _m) public pure returns(uint256) {
        if (_n >_m){
            return _n;
        }
        else{
            return _m;
        }
    }

}
