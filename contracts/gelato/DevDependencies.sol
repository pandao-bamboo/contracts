// "SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.6.10;

// NOTE:
//  This file's purpose is just to make sure buidler compiles all of depending
//  contracts during development.
//
//  For other environments, only use compiled contracts from the NPM package.
import {GelatoCore} from "@gelatonetwork/core/contracts/gelato_core/GelatoCore.sol";
import {GelatoManager} from "@gelatonetwork/core/contracts/helpers/GelatoManager.sol";
import {
  GelatoGasPriceOracle
} from "@gelatonetwork/core/contracts/gelato_core/GelatoGasPriceOracle.sol";

contract DevDependencies {}
