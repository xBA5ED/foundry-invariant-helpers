// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";

import "../src/BaseInvariant.sol";

import "./CounterHandler.sol";

contract CounterInvariants is BaseInvariant {
    Counter public counter;

    function setUp() targetSpecificSelectors public {
        CounterHandler _handler = new CounterHandler();
        targetContract(address(_handler));
    }

    // Write your invariants here
}
