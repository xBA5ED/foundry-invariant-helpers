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

    string contractLabel;

    AddressSet internal _actors;
    FunctionSet internal _functions;

    address internal currentActor;

    modifier createActor {
        _createActor(msg.sender, false);
        _;
    }

    modifier useActor(uint256 actorIndexSeed) {
        _useActor(actorIndexSeed);
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

    constructor(string memory _contractLabel) {
        contractLabel = _contractLabel;
    }

    function addToFunctionSet(string memory _label, bytes4 _selector) internal {
        _functions.add(_label, _selector);
    }

    function addActor(address _actor) public {
        _actors.add(_actor);
    }

    function selectors() external view returns (bytes4[] memory) {
        return _functions.selectors();
    }

    function logSummary() view external {
        _functions.log(contractLabel);
    }

    function _createActor(
        address _actor,
        bool allowContract
    ) internal {
        // The zero address is not a real actor, so instead we return some existing actor
        if(_actor == address(0))
            return _useActor(1);
        

        // If the sender is a contract and we do not allow contracts we get an existing actor
        // But we use the 'msg.sender' as the indexSeed
        if(!allowContract && address(_actor).code.length != 0)
            return _useActor(uint256(uint160(_actor)));
        

        // Store the new actor and return the address
        _actors.add(_actor);
        currentActor = _actor;
    }

    function _useActor(uint256 actorIndexSeed) internal {
         // Otherwise we will get 'address(0)' which isn't a real actor
        if (_actors.count() == 0) _actors.add(
            makeAddr("initialActor")
        );
        
        currentActor = _actors.rand(actorIndexSeed);
    }
 }