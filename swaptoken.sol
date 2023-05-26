
/**

 _______           _______  _______ _________ _______  _        _______  _       
(  ____ \|\     /|(  ___  )(  ____ )\__   __/(  ___  )| \    /\(  ____ \( (    /|
| (    \/| )   ( || (   ) || (    )|   ) (   | (   ) ||  \  / /| (    \/|  \  ( |
| (_____ | | _ | || (___) || (____)|   | |   | |   | ||  (_/ / | (__    |   \ | |
(_____  )| |( )| ||  ___  ||  _____)   | |   | |   | ||   _ (  |  __)   | (\ \) |
      ) || || || || (   ) || (         | |   | |   | ||  ( \ \ | (      | | \   |
/\____) || () () || )   ( || )         | |   | (___) ||  /  \ \| (____/\| )  \  |
\_______)(_______)|/     \||/          )_(   (_______)|_/    \/(_______/|/    )_)
                                                                                 
    ✅website https://linktr.ee/swaptoken

*/

// SPDX-License-Identifier: MIT

// Developed with the assistance of OpenAI's GPT-4

// OpenZeppelin Contracts

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SwapToken is Ownable, ERC20 {
    bool public limited;
    uint256 public maxHoldingAmount;
    uint256 public minHoldingAmount;
    address public uniswapV2Pair;

    // Define the dead wallet and marketing wallet
    address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
    address public marketingWallet = 0xD1287Aa6a54a7744C1d333CF385bA7Aba2626572;

    constructor() ERC20("SwapToken", "TOKEN") {
        // Mint 21 trillion tokens to the contract creator
        _mint(msg.sender, 21 * 10**12 * 10**9); // 21 trillion tokens with 9 decimals
    }

    function decimals() public view virtual override returns (uint8) {
        return 9;
    }

    function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
        limited = _limited;
        uniswapV2Pair = _uniswapV2Pair;
        maxHoldingAmount = _maxHoldingAmount;
        minHoldingAmount = _minHoldingAmount;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) override internal virtual {
        if (uniswapV2Pair == address(0)) {
            require(from == owner() || to == owner(), "trading is not started");
            return;
        }

        if (limited && from == uniswapV2Pair) {
            require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
        }
    }

    function burn(uint256 value) external {
        _burn(msg.sender, value);
    }
}


