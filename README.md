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
