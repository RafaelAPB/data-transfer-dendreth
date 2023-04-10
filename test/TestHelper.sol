pragma solidity 0.8.9;
import "forge-std/Test.sol";
import "forge-std/console2.sol";
contract TestHelper {
    address constant IMPORTANT_ADDRESS = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    //SomeContract someContract;
    constructor() {
    }
    
function stringToAddress(string memory _addressString) public pure returns (address) {
    bytes memory _addressBytes = bytes(_addressString);
    uint256 _addrLen = _addressBytes.length;
    require(_addrLen == 42, "Invalid address length");
    require(_addressBytes[0] == 0x30 && _addressBytes[1] == 0x78, "Invalid address format");

    bytes20 _address = bytes20(0);
    for (uint256 i = 2; i < _addrLen; i++) {
        _address |= bytes20(_addressBytes[i] & 0xFF) >> ((i - 2) * 8);
    }

    return address(_address);
}


function char(bytes1 b) internal pure returns (bytes1 c) {
    if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
    else return bytes1(uint8(b) + 0x57);
}

function toAsciiString(address x) public pure returns (string memory) {
    bytes memory s = new bytes(40);
    for (uint i = 0; i < 20; i++) {
        bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
        bytes1 hi = bytes1(uint8(b) / 16);
        bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
        s[2*i] = char(hi);
        s[2*i+1] = char(lo);            
    }
    return string(s);
}

    function stringToUint(string memory str) public pure returns (uint) {
        uint result = abi.decode(bytes(str), (uint));
        return result;
    }

    function toHex16 (bytes16 data) internal pure returns (bytes32 result) {
        result = bytes32 (data) & 0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000 |
            (bytes32 (data) & 0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000) >> 64;
        result = result & 0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000 |
            (result & 0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000) >> 32;
        result = result & 0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000 |
            (result & 0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000) >> 16;
        result = result & 0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000 |
            (result & 0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000) >> 8;
        result = (result & 0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000) >> 4 |
            (result & 0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00) >> 8;
        result = bytes32 (0x3030303030303030303030303030303030303030303030303030303030303030 +
            uint256 (result) +
            (uint256 (result) + 0x0606060606060606060606060606060606060606060606060606060606060606 >> 4 &
            0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F) * 7);
    }

    function toHex (bytes32 data) public pure returns (string memory) {
        return string (abi.encodePacked ("0x", toHex16 (bytes16 (data)), toHex16 (bytes16 (data << 128))));
    }

    function addressToBytes32(address _address) public pure returns (bytes32) {
    bytes memory addressBytes = new bytes(20);
    assembly {
        mstore(add(addressBytes, 32), _address)
    }
    return bytes32(uint256(keccak256(addressBytes)));
}
}