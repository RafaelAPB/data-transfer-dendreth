set -e
source .env

CONTRACT_SRC="src/ProxyContract.sol"
CONTRACT_NAME="ProxyContract"
RPC=$RPC_URL_MUMBAI

# Following script deploys proxy without dynamically changing their addresses
forge create --rpc-url $RPC \
--private-key $PRIVATE_KEY \
--etherscan-api-key $ETHERSCAN_POLYGON_KEY \
--verify \
$CONTRACT_SRC:$CONTRACT_NAME

# Replaces newly deployed relay contract and deploys proxy 
forge script script/DeployModifiedProxy.s.sol:DeployModifiedProxy --fork-url $RPC_URL_MUMBAI --private-key $PRIVATE_KEY \
--etherscan-api-key $ETHERSCAN_POLYGON_KEY --ffi --broadcast --verify
