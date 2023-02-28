// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {BaseHandler} from "./BaseHandler.sol";

import {CommonBase} from "forge-std/Base.sol";
import {console2} from "forge-std/console2.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

 contract BaseInvariant is CommonBase, StdInvariant {

    modifier targetSpecificSelectors {
        // Perform the setup
        _;

        // Only target the specified selectors
        address[] memory _targetedContracts = targetContracts();
        for(uint256 _i; _i < _targetedContracts.length;){
            address _target = _targetedContracts[_i];
            // Get the selectors from the target
            try BaseHandler(_target).selectors() returns(bytes4[] memory _selectors) {
                targetSelector(
                    FuzzSelector({
                        addr: _target,
                        selectors: _selectors
                    })
                );
            } catch {}
            unchecked{
                ++_i;
            }
        }
    }

    function invariant_callSummary() public {
        address[] memory _targetedContracts = targetContracts();
        console2.log("Call summary:");
        console2.log("-------------------");
        for(uint256 _i; _i < _targetedContracts.length;){
            address _target = _targetedContracts[_i];
            try BaseHandler(_target).logSummary() {} catch {}
            unchecked{
                ++_i;
            }
        }
        console2.log("-------------------");
    }
 }