pragma solidity 0.8.9;

import {Script} from '../lib/forge-std/src/Script.sol';
import {TestHelper} from "../test/TestHelper.sol";
import {RelayContract} from "../src/RelayContract.sol";
import "forge-std/Test.sol";
import '../src/ProxyContract.sol';

contract DeployModifiedRelay is Script {
  
    function run() external {
       
        vm.startBroadcast();
        RelayContract relay = new RelayContract();
        console.log("Deployed relay address: ", address(relay));
        vm.stopBroadcast();
  }
} 
