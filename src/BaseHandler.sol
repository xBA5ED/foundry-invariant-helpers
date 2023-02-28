// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AddressSet, LibAddressSet} from "./helpers/AddressSet.sol";
import {FunctionSet, LibFunctionSet} from "./helpers/FunctionSet.sol";

import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {console} from "forge-std/console.sol";
import {StdAssertions} from "forge-std/StdAssertions.sol";
import {console2} from "forge-std/console2.sol";

 contract BaseHandler is CommonBase, StdCheats, StdUtils, StdAssertions {
    using LibAddressSet for AddressSet;
    using LibFunctionSet for FunctionSet;

    mapping(bytes32 => uint256) public calls;

    AddressSet internal _actors;
    FunctionSet internal _functions;

    address internal currentActor;

    modifier createActor() {
        currentActor = msg.sender;
        _actors.add(msg.sender);
        _;
    }

    modifier useActor(uint256 actorIndexSeed) {
        currentActor = _actors.rand(actorIndexSeed);
        _;
    }

    modifier register {
        _functions.increment(msg.sig);
        _;
    }

    modifier registerCall {
        _functions.increment(msg.sig);
        _;
    }

    constructor() {
        
    }

    function addToFunctionSet(string memory _label, bytes4 _selector) internal {
        _functions.add(_label, _selector);
    }

    function selectors() external view returns (bytes4[] memory) {
        return _functions.selectors();
    }

    function logSummary() view external {
        _functions.log();
    }
 }