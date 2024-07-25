### AkashGamingToken
The AkashGamingToken is an ERC20 token contract for a gaming application. It allows the owner to mint tokens, add new in-game items, and manage token transfers and redemptions. Players can redeem tokens for in-game items, and the contract ensures proper validation of item availability and user balance during transactions. Additionally, the contract supports token burning by any user and includes functions to view item details and check balances.

### Description
The AkashGamingToken contract is a smart contract written in Solidity for the Ethereum blockchain. It implements an ERC-20 token along with allocating 100 ETH token in allocateToken function and burn 10 ETH token ,transferring 10 ETH Token to another address and specifying ingame item details in addGameItem function and redeem token.After that in viewItemDetails function the redeem amount of gaming item along with its whole information is shown.This contract offers a safe and uniform method for allocating tokens by showcasing the usage of OpenZeppelin's ERC-20 implementation. It can act as the basis for more  complex project.

### GettingStarted
 ### Executing program
 To run this program, you will need to use Remix, an online Solidity IDE. Follow these steps to get started:

Visit Remix: Go to https://remix.ethereum.org/. Create a New File: Click on the "+" icon in the left-hand sidebar to create a new file. Save the File: Save the file with a .sol extension (e.g.,  AkashGamingToken.sol). Copy and Paste Code: Copy and paste the following code into the new file:

```solidity
pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AkashGamingToken is ERC20, Ownable(msg.sender) {

    // Event emitted when tokens are redeemed for an item.
    event Redeem(address indexed from, uint256 itemId);

    // Enum to represent the type of in-game item
    enum ItemType { Gun, Bullet, Medication, Accessory, Rifle }

    // Struct to represent an ingame item
    struct GameItem {
        uint itemId;
        string name;
        ItemType categoryNo;
        uint256 price;   
        uint quantity;
    }

    // Mapping of item ID to item details
    mapping(uint256 => GameItem) public items;

    uint256 private itemIdGenerator;

    constructor() ERC20("AkashGamingToken", "ETH") {}

    function allocateToken(address to, uint256 amount) external onlyOwner {
        require(amount > 0, "Amount must be > than 0");
        _mint(to, amount);
    }

    function burnToken(uint256 amount) external {
        _burn(msg.sender, amount);
    }
//Allow to add new ingame item
    function addGameItem(
        string memory Itemname,
        ItemType categoryNo,
        uint256 price ,
        uint256 quantity
         ) external onlyOwner {
        require(price > 0, "Price > than 0");
        require(quantity > 0, "Stock must be > than 0");

        itemIdGenerator = itemIdGenerator+ 1;
        items[itemIdGenerator] = GameItem(itemIdGenerator, Itemname, categoryNo, price, quantity);
    }

    function Tokenredeem(uint256 itemId, uint256 amount) external {
        GameItem storage item = items[itemId];
        require(item.itemId != 0, "Item does not exist");
        require(item.quantity >= amount, "Item out of stock");

        uint256 Totalprice = item.price * amount;
        require(balanceOf(msg.sender) >= Totalprice, "Insufficient balance");

       
        _burn(msg.sender, Totalprice);
        item.quantity = item.quantity-amount;

        emit Redeem(msg.sender, itemId);
    }

    function viewItemDetails(uint256 itemId) external view returns (uint , string memory, ItemType, uint256, uint) {
        GameItem memory item = items[itemId];
        require(item.itemId != 0, "Item does not exist");
        return (item.itemId, item.name, item.categoryNo, item.price, item.quantity);
    }

    function checkBalance()public view returns(uint){
        return balanceOf(msg.sender);
    }

    // Function to transfer tokens to another address
    function TokenTransfer(address to, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient Balance");

        _transfer(msg.sender, to, amount);
    }
}

```

To run the program, follow these steps:

Compile the Code:

Click on the "Solidity Compiler" tab in the left-hand sidebar. Ensure the "Compiler" option is set to a compatible version, such as "0.8.20". Click on the "Compile AkashGamingToken.sol" button. Deploy the Contract:

Click on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "AkashGamingToken" contract from the dropdown menu. Click on the "Deploy" button. Interact with the Contract:

On allocating the 100 ETH token in contract address when contract is deployed .Burn the 10 ETH token from same address and call the check balance by putting same address and verify that token is deducted on not. Initialising Gaming item details in addGameItem and redeem it by putting itemId along with quantity.Transfer token to another address and also verify it in check balance. viewItemdetails: check it is redeemed.

### Author
Akash Singh

### License
This project is licensed under the MIT License
