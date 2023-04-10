pragma solidity 0.8.9;
import "forge-std/Test.sol";
import {RelayContract} from "../src/RelayContract.sol";
import "forge-std/console2.sol";
import {TestHelper} from "./TestHelper.sol";
import {BeaconLightClient} from "DendrETH/truth/eth/BeaconLightClient.sol";
import {ILightClient} from "../src/ILightClient.sol"; 
import '../src/ProxyContract.sol';
import '../src/SimpleStorage.sol';

contract RelayTest is Test {
    TestHelper helper = new TestHelper();

    uint256 goerliFork;
    uint256 mumbaiFork;
    uint256 FORK_MUMBAI_BLOCK_NUMBER = 37873993;
    //string FORK_MUMBAI_BLOCK_NUMBER = vm.envString("FORK_MUMBAI_BLOCK_NUMBER");
    //string DEPLOYED_MUMBAI_RELAY =  vm.envString("CONTRACT_TARGETCHAIN_RELAY_MUMBAI");
    address internal constant DEPLOYED_MUMBAI_RELAY =  0x5e6fFC41Af2079D5cc96C71AD93Cc128A3F2e428;
    string RPC_URL_GOERLI = vm.envString("RPC_URL_GOERLI");
    string RPC_URL_MUMBAI = vm.envString("RPC_URL_MUMBAI");

    function setUp() public {
        goerliFork = vm.createFork(RPC_URL_GOERLI);
        mumbaiFork = vm.createFork(RPC_URL_MUMBAI);

    }

    function testForkIdDiffer() view public {
        assert(goerliFork != mumbaiFork);
    }
    function testCanSetForkBlockNumberGoerli() public {
        vm.selectFork(goerliFork);
        vm.rollFork(1_337_000);

        assertEq(block.number, 1_337_000);
    }
    function testRelayMumbai() public {
        vm.selectFork(mumbaiFork);

    }

    // function testDeployedMumbaiAddress() public {
    //     console.log(DEPLOYED_MUMBAI_RELAY);
    //     assertEq(DEPLOYED_MUMBAI_RELAY, "0x5e6fFC41Af2079D5cc96C71AD93Cc128A3F2e428");
    //     address relayAddress = helper.stringToAddress(DEPLOYED_MUMBAI_RELAY);
    //     console.log(relayAddress);
    //     assertEq(relayAddress, 0x5e6fFC41Af2079D5cc96C71AD93Cc128A3F2e428);
    // }

    function testNewRelay() public {
        RelayContract relay = new RelayContract();
        console.log(address(relay));
        assertEq(relay.getDendrETH(), 0xcbF3850657Ea6bc41E0F847574D90Cf7D690844c);
    }

    function testDeployedRelayAtBlock33359283() public {
        vm.selectFork(mumbaiFork);
        vm.rollFork(FORK_MUMBAI_BLOCK_NUMBER);
        assertEq(block.number, FORK_MUMBAI_BLOCK_NUMBER);
        RelayContract relay = RelayContract(DEPLOYED_MUMBAI_RELAY);
        console.log(address(relay));
                assertEq(relay.getDendrETH(), 0xA3418F79c98A3E496A5E97610a97f82daE364619);

    }

    function testAddBlockDendreth () public {
        // we need to select the fork because that's where the beacon is deployed
        vm.selectFork(mumbaiFork);
        vm.rollFork(FORK_MUMBAI_BLOCK_NUMBER);
        RelayContract relay = new RelayContract();
        address beaconAddress = relay.getDendrETH();
        ILightClient beacon = ILightClient(beaconAddress);
        bytes32 root = beacon.executionStateRoot();
        relay.addBlockDendreth(42);
        assertEq(relay.getStateRoot(42), root);
    }    

    function testGetExecutionRoot () public {
        // we need to select the fork because that's where the beacon is deployed
        vm.selectFork(mumbaiFork);
        vm.rollFork(FORK_MUMBAI_BLOCK_NUMBER);
        RelayContract relay = new RelayContract();
        address beaconAddress = relay.getDendrETH();
        emit log_address(beaconAddress);
        ILightClient beacon = ILightClient(beaconAddress);
        uint256 index = beacon.currentIndex();
        emit log_uint(index);
        bytes32 root = beacon.executionStateRoot();
        emit log_bytes32(root);
        assertEq(root, 0xa60f3a729a502dfec00739a1078ba5819581b4d45f7ea6407d0e2f0bc98a1597);
    }    

    function testGetRelay () public {
        // we need to select the fork because that's where the beacon is deployed
        vm.selectFork(mumbaiFork);
        vm.rollFork(FORK_MUMBAI_BLOCK_NUMBER);
        RelayContract relay = new RelayContract();
        relay.getDendrETH();
    }    
}
