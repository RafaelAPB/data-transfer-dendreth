set -ex
source .env

forge script DeployModifiedRelay --fork-url $RPC_URL  --private-key $ANVIL_KEY --broadcast --ffi
forge script DeployModifiedProxy --fork-url $RPC_URL  --private-key $ANVIL_KEY --broadcast --ffi


cast send "0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0" "addBlock(bytes,uint)" "" 1 \
--private-key $ANVIL_KEY --rpc-url $RPC_URL

cast rpc eth_getBlockByNumber "latest" "false"  --rpc-url $RPC_URL

cast call "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512" "getRelayAddress()(address)" --rpc-url $RPC_URL
