// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract SocialSummerNightAward  {

    address public governance;

    event ChangeGovernance(address oldGovernance, address newGovernance);
    event GovernanceClaim(address erc20, address payable to, uint256 amount);

    constructor () {
        governance = msg.sender;
    }

    function changeGovernance(address _newGovernance) public {
        require(msg.sender == governance, 'Not governance');
        address oldGovernance = governance;
        governance = _newGovernance;
        emit ChangeGovernance(oldGovernance, _newGovernance);
    }

    function governanceClaim(address erc20, address payable to, uint256 amount) public {
        require(msg.sender == governance, 'Not governance');
        if (erc20 == address(0)){
            require(address(this).balance >= amount, 'Invalid amount');
            to.transfer(amount);
        } else {
            require(IERC20(erc20).balanceOf(address(this))>=amount, 'Invalid amount');
            IERC20(erc20).transfer(to, amount);
        }
        emit GovernanceClaim(erc20, to, amount);
    }

    receive() external payable {}
}
