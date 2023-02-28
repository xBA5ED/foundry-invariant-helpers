// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 _count;

    function get() external view returns (uint256) {
        return _count;
    }

    function set(uint256 _newCount) external {
        _count = _newCount;
    }

    function increment() external {
        ++_count;
    }

    function decrement() external {
        --_count;
    }
}