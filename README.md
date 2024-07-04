# project(module4) ETH-AVAX

## Description

This Solidity smart contract, DegenAkashToken, is an ERC20 token named "DGNGaming" with the symbol "DGN." It inherits from OpenZeppelin's ERC20 and Ownable contracts. The contract allows the owner to mint tokens and assign achievements to players, where each player can have multiple achievements with scores between 0 and 100. Players can check their token balance, transfer tokens to others, and redeem tokens for game rewards based on their achievements. The contract includes functionality for burning tokens, both through an internal burn function and a public function allowing users to burn their tokens directly. The token has no decimal places.


### Prerequisites

- Ensure you have access to an Ethereum-compatible wallet (e.g., MetaMask).
- Connect to an Ethereum network using Remix or a similar development environment.

### Installation
To interact with `DegenAkashToken`:

1. **Set up Remix**
   - Visit [Remix](https://remix.ethereum.org/).
   - Create a new Solidity file, e.g., `project(module4).sol`.

2. **Copy and Paste Code**
   - Insert the contract code into `project(module4).sol`.

3. **Compile and Deploy**
   - Compile the code using the "Solidity Compiler" tab.
   - Deploy the contract using the "Deploy" tab.

### Contract Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenAkashToken is ERC20, Ownable(msg.sender) {
 
    struct Player {
        mapping(string => uint8) achievement; // Game level or achievement name 
    }

    // Mapping to store players
    mapping(address => Player) private players;

    // Events for assigning achievements and burning tokens
    event AchievementAssign(address indexed playerAddress, string achievementRank, uint8 score);
    event BurnedTokens(address indexed playerAddress, uint256 Tokenamount);

    constructor() ERC20("DGNGaming", "DGN") {
        transferOwnership(msg.sender);
    }

    // Assign an achievement to a player
    function setplayerAchievement(address playerAddress, string memory achievementRank, uint8 score) external onlyOwner {
        require(score <= 100, "Score must be between 0 and 100");
        players[playerAddress].achievement[achievementRank] = score;
        emit AchievementAssign(playerAddress, achievementRank, score);
    }

  
    function mintToken(address to, uint Tokenamount) public onlyOwner {
        require(to != address(0), "Invalid address");
        require(Tokenamount > 0, "Amount must be > zero");
        _mint(to, Tokenamount);
    }

  
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function checkBalance() external view returns (uint) {
        return balanceOf(msg.sender);
    }

    // Transfer tokens to another address
    function SendToken(address receiver, uint Tokenamount) external {
        require(receiver != address(0), "Invalid receiver address");
        require(balanceOf(msg.sender) >= Tokenamount, "Not enough tokens");
        _transfer(msg.sender, receiver, Tokenamount);
    }

    // Redeem tokens for game rewards
    function Tokenredeem(string memory achievementRank) external {
        require(balanceOf(msg.sender) > 0, "Insufficient tokens to redeem");
        uint8 score = players[msg.sender].achievement[achievementRank];
        require(score > 0, "Player must have at least one achievement assigned ");

        if (score > 90) {
            burn(30);
        } else if (score > 80) {
            burn(25);
        } else if (score > 70) {
            burn(20);
        } else if (score > 60) {
            burn(10);
        } else {
            burn(5);
        }
    }

    // Burn tokens internal from the caller's balance
    function burn(uint Tokenamount) internal {
        require(Tokenamount > 0, "Amount must be > zero");
        require(balanceOf(msg.sender) >= Tokenamount, "Don't have enough tokens");
        _burn(msg.sender, Tokenamount);
        emit BurnedTokens(msg.sender, Tokenamount);
    }

    // Public function to burn tokens from the caller's balance
    function burnToken(uint Tokenamount) external {
        burn(Tokenamount);
    }
}
```
## Executing program

After deployment, test the contract on Avalanche Fuji(Snowtrace testnet) Testnet:

1. **Use Tools**: Use tools like Remix  to interact with the deployed contract.
   
2. **Execute Transactions**: Execute transactions to perform the following actions:
   - Mint tokens using the `mintToken` function.
   - Assigning achievement to player by user through `setplayerAchievement` function.
   - Transfer tokens using the `SendToken` function.
   - Redeem tokens by players using the `Tokenredeem` function.
   - Burning token internally and publically using `burn` and `burnToken` function respectively.

4. **Functionalities Verification**: Verify that all functionalities behave as expected by checking balances, burning token, and token transfers.

## Verifying the Smart Contract on Snowtrace

To verify the contract on Snowtrace:

1. **Obtain Contract Address**: After deploying the contract on Avalanche Fuji Testnet, obtain the contract address from the deployment transaction.

2. **Visit Snowtrace**: Go to [Snowtrace](https://snowtrace.io/).

3. **Verify Contract Details**:
   - Enter the contract address in the search bar on Snowtrace.
   - Verify contract details including source code, functions, events, and contract status.
     
4.**performing all transaction**:

   - transaction perform on all the function like mint ,setplayerAchievement,redeem etc.
   - verify all these transation in snowtrace testnet.

     ## Usage

 ### Setting players Achievement
  Assign achievement to player
  
 ```solidity
 function setplayerAchievement(address playerAddress, string memory achievementRank, uint8 score) external onlyOwner {
        require(score <= 100, "Score must be between 0 and 100");
        players[playerAddress].achievement[achievementRank] = score;
        emit AchievementAssign(playerAddress, achievementRank, score);
    }
 ```
     
### Minting Tokens

Only the contract owner can mint new tokens.

```solidity

    function mintToken(address to, uint Tokenamount) public onlyOwner {
        require(to != address(0), "Invalid address");
        require(Tokenamount > 0, "Amount must be > zero");
        _mint(to, Tokenamount);
    }
```
### Transferring Tokens
Transfer tokens to another address.

```solidity
 function SendToken(address receiver, uint Tokenamount) external {
        require(receiver != address(0), "Invalid receiver address");
        require(balanceOf(msg.sender) >= Tokenamount, "Not enough tokens");
        _transfer(msg.sender, receiver, Tokenamount);
    }
```
### Burning Tokens
Burn tokens, from internal and public burn function.

```solidity
// internal function to burn token
function burn(uint Tokenamount) internal {
        require(Tokenamount > 0, "Amount must be > zero");
        require(balanceOf(msg.sender) >= Tokenamount, "Don't have enough tokens");
        _burn(msg.sender, Tokenamount);
        emit BurnedTokens(msg.sender, Tokenamount);
    }

    // Public function to burn tokens from the caller's balance
    function burnToken(uint Tokenamount) external {
        burn(Tokenamount);
    }
```
### checking balance
check balance from caller's address

```solidity
function checkBalance() external view returns (uint) {
        return balanceOf(msg.sender);
    }
```

### Redeeming Tokens 
players can redeem their tokens from achievement score and burn according to score.

```solidity
function Tokenredeem(string memory achievementRank) external {
        require(balanceOf(msg.sender) > 0, "Insufficient tokens to redeem");
        uint8 score = players[msg.sender].achievement[achievementRank];
        require(score > 0, "Player must have at least one achievement assigned ");

        if (score > 90) {
            burn(30);
        } else if (score > 80) {
            burn(25);
        } else if (score > 70) {
            burn(20);
        } else if (score > 60) {
            burn(10);
        } else {
            burn(5);
        }
    }
```

### Author
Akash Singh

### License
This project is licensed under the MIT License.
