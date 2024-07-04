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
