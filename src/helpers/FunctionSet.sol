// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {console2} from "forge-std/console2.sol";
import {VmSafe} from "forge-std/Vm.sol";

struct Function {
    string label;
    bytes4 selector;
}

struct FunctionSet {
    Function[] fncs;
    mapping(bytes4 => uint256) calledCount;
    mapping(bytes4 => bool) exists;
}

library LibFunctionSet {
    function add(FunctionSet storage s, string memory _label, bytes4 _selector) internal {
        if(s.calledCount[_selector] != 0){
            revert("warning: Method selector is already in the FunctionSet");
        }

        s.calledCount[_selector] = 1;
        s.fncs.push(Function({
            label: _label,
            selector: _selector
        }));
    }

    function increment(FunctionSet storage s, bytes4 _signature) internal {
        ++s.calledCount[_signature];
    }

    function selectors(FunctionSet storage s) internal view returns (bytes4[] memory _selectors) {
        // console2.log("Getting selectors");
        _selectors = new bytes4[](s.fncs.length);
        for(uint256 _i; _i < _selectors.length;){
            // console2.logBytes4(s.fncs[_i].selector);
            _selectors[_i] = s.fncs[_i].selector;
            unchecked {
                ++_i;
            }
        }
    }

    function log(FunctionSet storage s, string memory _functionPrefix) internal view {
        VmSafe vm = VmSafe(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        for(uint256 _i; _i < s.fncs.length;){
            Function storage _fnc = s.fncs[_i];
            console2.log(string.concat(
                "- ",
                _functionPrefix,
                "::",
                _fnc.label,
                ": ",
                vm.toString(s.calledCount[_fnc.selector] - 1)
            ));
            unchecked{
                ++_i;
            }
        }
    }

    // function contains(AddressSet storage s, address addr) internal view returns (bool) {
    //     return s.saved[addr];
    // }

    // function count(AddressSet storage s) internal view returns (uint256) {
    //     return s.addrs.length;
    // }

    // function rand(AddressSet storage s, uint256 seed) internal view returns (address) {
    //     if (s.addrs.length > 0) {
    //         return s.addrs[seed % s.addrs.length];
    //     } else {
    //         return address(0);
    //     }
    // }

    // function forEach(AddressSet storage s, function(address) external func) internal {
    //     for (uint256 i; i < s.addrs.length; ++i) {
    //         func(s.addrs[i]);
    //     }
    // }

    // function reduce(AddressSet storage s, uint256 acc, function(uint256,address) external returns (uint256) func)
    //     internal
    //     returns (uint256)
    // {
    //     for (uint256 i; i < s.addrs.length; ++i) {
    //         acc = func(acc, s.addrs[i]);
    //     }
    //     return acc;
    // }
}
