// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
import "../src/BaseHandler.sol";
import "./target/Counter.sol";

contract CounterHandler is BaseHandler {
    Counter public counter;

    constructor() {
        counter = new Counter();

        // Register all the functions that should be targeted
        addToFunctionSet("Increment", this.increment.selector);
        addToFunctionSet("Decrement", this.decrement.selector);
        addToFunctionSet("Set", this.set.selector);
    }

    function increment() register public {
        counter.increment();
    }

    function decrement() register public {
        counter.decrement();
    }

    function set(
        uint256 _amount
    ) register public {
        counter.set(_amount);
    }
}
