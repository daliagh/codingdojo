pragma solidity >=0.7.0 <0.8.0;

contract mappingcites {

    
    mapping(string => string)cities;
    
    function add (string memory _city, string memory _country)public{
        
        cities[_city]= _country;
    }
    
    function get (string memory _name)public view returns(string memory){
        
        return cities [_name];
        
    }
}
