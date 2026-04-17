// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.3;

contract Roulette {
    uint public betAmount = 0.01 ether;
    uint public maxBankBalance = 2 ether;
    address public owner;

    struct Bet {
        address player;
        uint8 betType;
        uint8 number;
    }

    Bet[] public bets;
    mapping(address => uint256) public winnings;

    event BetPlaced(address indexed player, uint8 betType, uint8 number);
    event SpinResult(uint256 number, bool winner);
    event Payout(address indexed player, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function placeBet(uint8 _betType, uint8 _number) external payable {
        require(msg.value == betAmount, "Invalid bet amount");
        require(_betType >= 0 && _betType <= 5, "Invalid bet type");
        require(_number >= 0 && _number <= 36, "Invalid number");
        bets.push(Bet(msg.sender, _betType, _number));
        emit BetPlaced(msg.sender, _betType, _number);
    }

    function spinWheel() external onlyOwner {
        require(bets.length > 0, "No bets placed");
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, blockhash(block.number - 1))));
        uint256 randNumber = seed % 37; // 0-36
        for (uint i = 0; i < bets.length; i++) {
            Bet memory b = bets[i];
            bool won = false;
            if (randNumber == 0 && b.betType == 5 && b.number == 0) {
                won = true;
            } else if (b.betType == 5 && b.number == randNumber) {
                won = true;
            } else if (b.betType == 4) {
                if (b.number == 0 && randNumber % 2 == 0) {
                    won = true;
                } else if (b.number == 1 && randNumber % 2 == 1) {
                    won = true;
                }
            } else if (b.betType == 3) {
                if (b.number == 0 && randNumber <= 18) {
                    won = true;
                } else if (b.number == 1 && randNumber >= 19) {
                    won = true;
                }
            } else if (b.betType == 2) {
                if (b.number == 0 && randNumber <= 12) {
                    won = true;
                } else if (b.number == 1 && randNumber > 12 && randNumber <= 24) {
                    won = true;
                } else if (b.number == 2 && randNumber > 24) {
                    won = true;
                }
            } else if (b.betType == 1) {
                if (b.number == 0 && randNumber % 3 == 1) {
                    won = true;
                } else if (b.number == 1 && randNumber % 3 == 2) {
                    won = true;
                } else if (b.number == 2 && randNumber % 3 == 0) {
                    won = true;
                }
            } else if (b.betType == 0) {
                // Black or Red (simplified)
                if (b.number == 0 && randNumber != 0 && randNumber % 2 == 0) {
                    won = true;
                } else if (b.number == 1 && randNumber != 0 && randNumber % 2 == 1) {
                    won = true;
                }
            }
            if (won) {
                uint256 payout = betAmount * getPayout(b.betType);
                winnings[b.player] += payout;
            }
        }
        delete bets;
        // Reset
        if (address(this).balance > maxBankBalance) {
            takeProfits();
        }
        emit RandomNumber(randNumber);
    }

    function getPayout(uint8 _betType) internal view returns (uint8) {
        if (_betType == 5) return 36;
        if (_betType == 4 || _betType == 3) return 2;
        if (_betType == 2 || _betType == 1) return 3;
        if (_betType == 0) return 2;
        return 0;
    }

    function cashOut() external {
        uint256 amount = winnings[msg.sender];
        require(amount > 0, "No winnings");
        require(amount <= address(this).balance, "Insufficient balance");
        winnings[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit Payout(msg.sender, amount);
    }

    function takeProfits() internal {
        uint256 profit = address(this).balance - maxBankBalance;
        if (profit > 0) {
            payable(owner).transfer(profit);
        }
    }

    function ownerKill() external onlyOwner {
        selfdestruct(payable(owner));
    }
}
