// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "../modified/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";

//import "@openzeppelin/upgrades/contracts/Initializable.sol";

contract ERTH is ERC777, Ownable {
    using SafeMath for uint256;
    using Address for address;

    // currentDelta at the last time of using the contract
    mapping (address => uint256) private _accountDeltas;

    // the current inflation delta
    uint256 private _currentPercentChange;

    constructor(address[] memory defaultOperators)
        public
        ERC777("ERTH: CO2 PPM", "ERTH", defaultOperators)
    {
        _currentPercentChange = 10000000000000000;
        //10000000000000000
        //10700000000000000
        _accountDeltas[msg.sender] = _currentPercentChange;
        _mint(msg.sender, 417160000000 * (10 ** uint256(decimals())), "", "");
    }

    ////////////////////////////////////////////////////////////
    // START OVERRIDING
    ////////////////////////////////////////////////////////////

    function balanceOf(address tokenHolder) public view override(ERC777) returns (uint256) {
        uint256 accountPercentChange = _accountDeltas[tokenHolder];
        if (accountPercentChange == _currentPercentChange || accountPercentChange == 0) {
            return _balances[tokenHolder];
        }

        return _balances[tokenHolder].mul(_currentPercentChange).div(accountPercentChange);
    }

    function _move(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData
    )
        internal virtual override(ERC777)
    {
        _beforeTokenTransfer(operator, from, to, amount);

        _updateBalance(from);
        _updateBalance(to);

        _balances[from] = _balances[from].sub(amount, "ERC777: transfer amount exceeds balance");
        _balances[to] = _balances[to].add(amount);

        emit Sent(operator, from, to, amount, userData, operatorData);
        emit Transfer(from, to, amount);
    }

    /**
     * @dev Burn tokens
     * @param from address token holder address
     * @param amount uint256 amount of tokens to burn
     * @param data bytes extra information provided by the token holder
     * @param operatorData bytes extra information provided by the operator (if any)
     */
    function _burn(
        address from,
        uint256 amount,
        bytes memory data,
        bytes memory operatorData
    )
        internal virtual override(ERC777)
    {
        require(from != address(0), "ERC777: burn from the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), amount);

        _callTokensToSend(operator, from, address(0), amount, data, operatorData);


        _updateBalance(from);

        // Update state variables
        _balances[from] = _balances[from].sub(amount, "ERC777: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);

        emit Burned(operator, from, amount, data, operatorData);
        emit Transfer(from, address(0), amount);
    }


    ////////////////////////////////////////////////////////////
    // END OVERRIDING
    ////////////////////////////////////////////////////////////

    function setCurrentTotalPercentChange(uint256 product) public onlyOwner returns (string memory) {
        _totalSupply = _totalSupply.mul(product).div(_currentPercentChange);
        _currentPercentChange = product;
    }

    function _updateBalance(address account) internal {
        uint256 accountPercentChange = _accountDeltas[account];
        if (accountPercentChange == _currentPercentChange) {
            return;
            // do nothing
        }
        if (accountPercentChange == 0) {
            _accountDeltas[account] = _currentPercentChange;
            return;
        }

        _accountDeltas[account] = _currentPercentChange;
        _balances[account] = _balances[account].mul(_currentPercentChange).div(accountPercentChange);
    }
}