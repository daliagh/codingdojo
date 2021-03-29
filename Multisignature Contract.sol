//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
contract TechInsurance{
    /** 
     *Defined two structs one for (Product) other for (Client)
     */
    struct Product {
        uint product_Id;
        string product_Name;
        uint product_Price;
        bool GivenOffered;
        address Product_Owner_Address;
        address buyer_Address;
        }
    struct Client {
        bool isValid;
        uint time;
    }
    
    //here two event one for Product other for , use event to emit
    event productLoaded(uint product_Id,string product_Name, uint product_Price,bool GivenOffered);
  
    //here list of mapping why I put M berfor each mapp to I know is releted with mapping
     mapping(address => mapping(uint => Client)) public client;
     mapping(uint => Product) public MproductIndex; // map the productCounter to a Product
     mapping(uint256=>address) public Owners;
     mapping(address=>uint256) public Balances;
     mapping (address => bool) public isAdmin;
     
    
    //here constructor & Modifiers
    address [] public authenticators ; // Arry to store address of authenticators 
    address public contractOwner;

     constructor( ) public {
        contractOwner = msg.sender;
        isAdmin[msg.sender] = false;
     }
    uint NumOfConfirmation=2;
    address payable owner;
   
    // 1- only contract owner 
    modifier onlyOwner {
        require( msg.sender == owner,"Only owner can call this function." );
         _;
    }
    // 2- check the contract owner 
    modifier onlyContractOwner() {
        require(msg.sender == contractOwner, "Not contract owner");
        _;
    }
    // 3- check the address should be not null
    modifier NotZero(address Address){
        require(Address != address(0));
        _;
    }
    // 4- check the Authenticator is Exist 
    modifier AuthenticatorExist(address _address) {
        require(isAdmin[_address] == false, "already added!");
        _;
    }
    modifier Confirmation (){
        require(getAuths().length==NumOfConfirmation,"you can't add should have 2 Confirmation");
        _;
    }
    function getAuths() public view returns (address[] memory){
        return authenticators;
    }
    function addAuths(address _address) public onlyContractOwner() AuthenticatorExist(_address) NotZero(_address) {
         isAdmin[_address] = true;
        
    }
    function Authrize() public  returns (uint _x) {
        require(isAdmin[msg.sender] == true, "no you can't");
        authenticators.push(msg.sender);
        return (authenticators.length);
    }
    function ownerOf(uint256 _tokenId) public view  returns (address) {
          address Owner = MOwners[_tokenId];
         require(Owner != address(0));
         return Owner;
    }
    
    function balanceOf(address _InsuranceOWner) public view  returns(uint256) {
        require(_InsuranceOWner != address(0));
        return MBalances[owner];
    }
    
    function _mint(address _to, uint256 _tokenId) public {
        MBalances[_to] +=1;
        MOwners[_tokenId]=_to;
    }

    uint productCounter;    
    
    function addProduct(uint _productId, string memory _productName, uint _price ) Confirmation public  {
        productCounter++;
        MproductIndex [productCounter] = Product (_productId , _productName , _price , true, msg.sender, address(0));
        _mint(msg.sender,productCounter);
        emit productLoaded(_productId,_productName,_price,true);
    }
    
     function Fatch(uint _productId)public view returns(uint product_Id ,string memory product_Name,uint product_Price, bool GivenOffered ,address owneer,address buyer){
      product_Id =MproductIndex [_productId].product_Id;
      product_Name =MproductIndex [_productId].product_Name;
      product_Price = MproductIndex[_productId].product_Price;
      GivenOffered = MproductIndex[_productId].GivenOffered;
      owneer = MproductIndex[_productId].Product_Owner_Address;
      buyer = MproductIndex[_productId].buyer_Address;  
    } 
    
    function doNotOffer(uint _productIndex) public onlyContractOwner returns(bool) {
        return MproductIndex[_productIndex].GivenOffered = false;
    }
    
    function forOffer(uint _productIndex) public onlyContractOwner returns(bool) {
        return MproductIndex[_productIndex].GivenOffered = true;
    }
    
    function changePrice(uint _productIndex, uint _NewPrice) public onlyContractOwner  {
       // require( MproductIndex[_productIndex].product_Price>=1);
        MproductIndex[_productIndex].product_Price = _NewPrice;
    } 
    
    function buyInsurance(uint _productIndex) public payable {
      require(MproductIndex[_productIndex].GivenOffered == true);
      
      require(msg.value >= MproductIndex[_productIndex].product_Price ,"check the price of the Product");
      uint256 price = MproductIndex[_productIndex].product_Price;
      Client memory NewClient;
      NewClient.isValid=true;
      NewClient.time = block.number;
      client[msg.sender][_productIndex]= NewClient;
      address buyer =msg.sender;
      MproductIndex[_productIndex].buyer_Address = buyer; // update buyer address
      payable(msg.sender).transfer(price);
      MproductIndex[_productIndex].Product_Owner_Address = buyer;
    }
    
    function transferID( address to, uint256 tokenId) public onlyContractOwner {
        // this function to transfer the insurance to another owner
        require(msg.sender != to," Something wrong You are the owner !");
        require(to != address(0), "address to not 0 ");
        _transfer(msg.sender, to, tokenId);
     }
    
    function _transfer(address from, address to, uint256 tokenId) public onlyContractOwner  {
        require(to != address(0), "ERC721: transfer to the zero address");
        MBalances[from] -= 1;
        MBalances[to] += 1;
        MOwners[tokenId] = to;
    }
    

   
   
    
    
    
    
    
}
