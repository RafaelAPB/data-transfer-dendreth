pragma solidity 0.8.9;

import {TestHelper} from "../test/TestHelper.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol";
import "forge-std/Test.sol";
import {ProxyContract} from '../src/ProxyContract.sol';
import {SimpleStorage} from '../src/SimpleStorage.sol';
import {RelayContract} from '../src/RelayContract.sol';

contract DeployModifiedProxy is Script {
    TestHelper helper = new TestHelper();
    string source =  vm.envString("CONTRACT_SOURCECHAIN_SOURCE_GOERLI");
    string logic =  vm.envString("CONTRACT_TARGETCHAIN_LOGIC_MUMBAI");
    string relay =  vm.envString("CONTRACT_TARGETCHAIN_RELAY_MUMBAI");

    function run() external returns (ProxyContract proxy) {
        console.log("Using source address: ", source);
        console.log("Using logic address: ", logic);
        console.log("Using relay address: ", relay);

        string[] memory runJsInputs = new string[](6);
        runJsInputs[0] = 'npx'; 
        runJsInputs[1] = 'ts-node';
        runJsInputs[2] = 'script/modify-proxy-contract.ts';
        //runJsInputs[3] = vm.toString(address(relay));
        runJsInputs[3] = relay;
        runJsInputs[4] = source;
        runJsInputs[5] = logic;

        //Replace addresses in proxy contract
        vm.startBroadcast();
        bytes memory result = vm.ffi(runJsInputs);
        // log result
        console.logBytes(result);
        ProxyContract deployedProxy = new ProxyContract();
        console.log("Deployed proxy address: ", address(deployedProxy));
        vm.stopBroadcast();
        return deployedProxy;
  }
} 
