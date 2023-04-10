pragma solidity 0.8.9;

import "forge-std/Test.sol";
import {SimpleStorage} from "src/SimpleStorage.sol";
import "forge-std/console2.sol";

contract SimpleStorageTest is SimpleStorage,Test {

    function setUp() external {
        a = 1;
        b = 1;
        values[address(0x00a329c0648769A73afAc7F9381E08FB43dBEA72)] = 1;
    }

    function testGetA() external {
        assertEq(getA(), 1);
    }

    function testGetB() external {
        assertEq(getB(), 1);
    }

    function testGetValue() external {
        console2.log(msg.sender, "msg.sender");
        assertEq(getValue(msg.sender), 1);
        setValue(3);
        assertEq(getValue(msg.sender), 3);
        console.log(block.number);
    }

    function testSetA() external {
        setA(2);
        assertEq(getA(),2);
    }
}