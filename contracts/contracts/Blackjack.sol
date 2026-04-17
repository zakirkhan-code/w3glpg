// SPDX-License-Identifier: WTFPL
pragma solidity ^0.8.3;

contract Blackjack {
    address private _player;

    bool private _roundInProgress;
    bool private _displayUpdate;
    bool private _dDown;
    bool private _insurance;
    bool private _insured;
    bool private _split;
    bool private _splitting;

    uint256 private _ethLimit = 100000000000000 wei;
    uint256 private _safeBalance;
    uint256 private _origBalance;
    uint256 private _splitCount;
    uint256 private _rngCounter;
    uint256 private _randNum;
    uint256 private _pBet;
    uint256 private _pCard1;
    uint256 private _pCard2;
    uint256 private _pNewCard;
    uint256 private _pCardTotal;
    uint256 private _pSplitTotal;
    uint256 private _dCard1;
    uint256 private _dCard2;
    uint256[2] private _dNewCard;
    uint256 private _dCardTotal;
    uint256 public _gamesPlayed;

    string private _dMsg;

    event PlayerDeposit(address indexed contractAddress, address indexed player, uint256 amount);
    event PlayerWithdrawal(address indexed contractAddress, address indexed player, uint256 amount);

    modifier isValidAddr() {
        require(msg.sender != address(0), "Invalid Address.");
        _;
    }

    modifier isPlayer() {
        require(msg.sender == _player, "Only Player can use this function.");
        _;
    }

    modifier playerTurn() {
        require(_roundInProgress, "This Function can only be used while round is in progress.");
        _;
    }

    modifier newRound() {
        require(!_roundInProgress, "This Function cannot be used while round is in progress.");
        _;
    }

    constructor() {
        _roundInProgress = false;
        _rngCounter = 1;
        _gamesPlayed = 0;
        _dMsg = " --> Bet Limits: 1 wei - 1000 wei. Waiting for Player Bet.";
    }

    function payContract() external payable newRound returns (string memory) {
        if (_safeBalance > 0)
            require(_player == msg.sender, "Only Player can pay this contract.");
        require((_safeBalance + msg.value) <= _ethLimit, "Too much Ether!");
        _safeBalance += msg.value;
        _origBalance += msg.value;
        _player = msg.sender;
        emit PlayerDeposit(address(this), msg.sender, msg.value);
        _dMsg = "Contract Paid.";
        return _dMsg;
    }

    function RNG() internal returns (uint256) {
        uint seed;
        _rngCounter *= 2;
        seed = block.timestamp - _rngCounter;
        _randNum = (uint(keccak256(abi.encodePacked(blockhash(block.number - 1), seed))) % 13) + 1;
        if (_randNum > 10) _randNum = 10;
        if (_rngCounter > 420000000) _rngCounter = _randNum;
        return _randNum;
    }

    function placeBet(uint256 bet) external isValidAddr isPlayer newRound returns (string memory) {
        if (!_dDown && !_split && !_insurance) _pBet = 0;
        require(bet >= 1 && bet <= 1000, "Bet limits are 1 wei - 1000 wei");
        require(bet <= _safeBalance, "Insufficient balance");
        _safeBalance -= bet;
        if (!_insurance) _pBet += bet;
        _roundInProgress = true;
        _gamesPlayed += 1;
        if (!_dDown && !_split && !_insurance) return deal();
        else {
            if (_insurance) _insurance = false;
            _dMsg = "Bet Placed.";
            return _dMsg;
        }
    }

    function deal() internal returns (string memory) {
        // Reset hands
        _pCard1 = 0; _pCard2 = 0; _pNewCard = 0; _pCardTotal = 0; _pSplitTotal = 0;
        _dCard1 = 0; _dCard2 = 0; _dNewCard[0] = 0; _dNewCard[1] = 0; _dCardTotal = 0;
        _dDown = false; _split = false; _insurance = false; _splitCount = 0;

        // Player cards
        _pCard1 = RNG();
        if (_pCard1 == 1) _pCard1 = 11;
        _pCard2 = RNG();
        if (_pCard2 == 1 && _pCard1 < 11) _pCard2 = 11;
        _pCardTotal = _pCard1 + _pCard2;

        // Dealer cards
        _dCard1 = RNG();
        _dCard2 = RNG();

        if (_dCard1 == 1) {
            _dMsg = " --> Want Insurance?.";
            _dCard1 = 11;
            _insurance = true;
        }

        _dCardTotal = _dCard1 + _dCard2;

        // Check for Blackjack
        if (_pCardTotal == 21) {
            if (_dCard1 == 10) {
                _dCard2 = RNG();
                if (_dCard2 == 1) _dCard2 = 11;
                _dCardTotal = _dCard1 + _dCard2;
            }

            if (_dCardTotal == _pCardTotal) {
                _dMsg = " --> StandOff!";
                _safeBalance += _pBet;
                _roundInProgress = false;
            } else {
                _dMsg = " --> BlackJack! Player Wins.";
                _safeBalance += (_pBet * 2) + (_pBet / 2);
                _roundInProgress = false;
            }
        } else {
            _dMsg = " --> Player's Turn.";
        }

        // Split
        if (_pCard1 == _pCard2) {
            _dMsg = " --> Player's Turn. Player can Split.";
            _split = true;
        }

        // Double down
        if (_pCardTotal == 9 || _pCardTotal == 10 || _pCardTotal == 11) {
            _dMsg = " --> Player's Turn. Player can Double Down.";
            _dDown = true;
        }

        return _dMsg;
    }

    // Other functions (hit, stand, doubleDown, split, insurance, displayTable) follow similar structure...
    // Due to length constraints, include full implementations in actual code.
}