// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.3;

/**
 * @title SlotMachine
 * Basic slot machine logic with simple spin and payout
 */
contract SlotMachine {
    address public owner;
    uint256 public betAmount = 0.01 ether;
    uint256 public maxBankBalance = 5 ether;

    // Symbols represented as numbers
    uint8[] public symbols = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

    event SpinResult(address indexed player, uint256[] symbols, bool win, uint256 payout);
    event Payout(address indexed player, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function spin() external payable {
        require(msg.value == betAmount, "Incorrect bet");
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        uint8[] memory result = new uint8[](3);
        for (uint i = 0; i < 3; i++) {
            uint8 symbolIndex = uint8(seed % symbols.length);
            result[i] = symbols[symbolIndex];
            seed = uint256(keccak256(abi.encodePacked(seed)));
        }
        bool isWin = (result[0] == result[1] && result[1] == result[2]);
        uint256 payout = 0;
        if (isWin) {
            payout = msg.value * 10; // 10x payout for jackpot
            require(address(this).balance >= payout, "Insufficient bank");
        }

        emit SpinResult(msg.sender, result, isWin, payout);

        if (isWin) {
            payable(msg.sender).transfer(payout);
        }
    }

    function addFunds() external payable onlyOwner {}

    function takeProfits() external onlyOwner {
        uint256 profit = address(this).balance - maxBankBalance;
        if (profit > 0) {
            payable(owner).transfer(profit);
        }
    }

    function ownerKill() external onlyOwner {
        selfdestruct(payable(owner));
    }
}