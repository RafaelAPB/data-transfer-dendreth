
import FileHandler from "./fileHandler";
import * as dotenv from "dotenv";
dotenv.config();

const log = require('simple-node-logger').createSimpleLogger();
const PROXY_CONTRACT_FILE_PATH = "ProxyContract.sol";

log.warn("remember to check placeholders");


let relayAddress = process.argv[2];
log.info(`relayAddress ${relayAddress}`);
let sourceAddress = process.argv[3];
log.info(`sourceAddress ${sourceAddress}`);
let logicAddress = process.argv[4];
log.info(`logicAddress ${logicAddress}`);

if (!relayAddress || !sourceAddress || !logicAddress) {
    log.info("missing arguments");
    process.exit(-1);
}

try {
    const fh = new FileHandler(`${__dirname}/../src/${PROXY_CONTRACT_FILE_PATH}`);
    const file = fh.read();
    if (!file) {
        throw new Error(`Could not read file ${PROXY_CONTRACT_FILE_PATH}`);
    }   
    let replacement = file; 
    let placeholder_relay = /RELAY_ADDRESS\s*=\s*(0x[a-fA-F0-9]{40})\s*;/g;
    let placeholder_source = /SOURCE_ADDRESS\s*=\s*(0x[a-fA-F0-9]{40})\s*;/g;
    let placeholder_logic = /LOGIC_ADDRESS\s*=\s*(0x[a-fA-F0-9]{40})\s*;/g;

    replacement = replacement.replace(placeholder_relay, constructRelayAddressReplacement(relayAddress));
    replacement = replacement.replace(placeholder_source, constructSourceAddressReplacement(sourceAddress));
    replacement = replacement.replace(placeholder_logic, constructLogicAddressReplacement(logicAddress));

    // write
    fh.write(replacement as string);
} 

    catch (error) {
        log.error(error);
        process.exit(-1);
    }


function enforceStartWith0X(address: string) {
    if (!address.startsWith("0x")) {
        return `0x${address}`;
    }
    return address;
}

function constructRelayAddressReplacement(relayAddress: string) {
    return `RELAY_ADDRESS = ${enforceStartWith0X(relayAddress)};`;
}

function constructSourceAddressReplacement(sourceAddress: string) {
    return `SOURCE_ADDRESS = ${enforceStartWith0X(sourceAddress)};`;
}

function constructLogicAddressReplacement(logicAddress: string) {
    return `LOGIC_ADDRESS = ${enforceStartWith0X(logicAddress)};`;
}