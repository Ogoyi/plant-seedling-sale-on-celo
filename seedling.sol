// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


interface IERC20Token {
   function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract SeedlingsMarketplace {
    
    
    uint internal seedlingsLength = 0;
    address internal cUsdTokenAddress =  0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct  Seedling {
        address payable owner;
        string name;
        string species;
        string description;
        uint price;
         
        
    }
     mapping (uint =>  Seedling) internal seedlings;

      function  addSeedling(
        string memory _name, 
        string memory _species,
        string memory _description,
        uint _price

          ) public {
       Seedling storage seedling = seedlings[seedlingsLength];


         seedling.owner = payable(msg.sender);
           seedling.name = _name;
           seedling.species = _species;
           seedling.description = _description;
              seedling.price = _price;

  
        seedlingsLength++;
          }

          
     function getSeedling(uint _index) public view returns (
        address payable,
        string memory,  
        string memory,
        string memory,
        uint
        
    ) {
        return (  
            seedlings[_index].owner,
             seedlings[_index].name,
              seedlings[_index].species,
              seedlings[_index].description,
                 seedlings[_index].price
               
        );
    }


     function replaceSeedlingDescription(uint _index, string memory _description) public {
        require(msg.sender == seedlings[_index].owner, "Only the owner can change the description");
        seedlings[_index].description = _description;
     }

    
      function buySeedling(uint _index) public payable  {
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            seedlings[_index].owner,
            seedlings[_index].price
          ),
          "Transfer failed."
        );

         seedlings[_index].owner = payable(msg.sender);
         
    }

     function getSeedlingsLength() public view returns (uint) {
        return (seedlingsLength);
    }
}
