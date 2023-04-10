set -e
source .env

CONTRACT_SRC="src/SimpleStorage.sol"
CONTRACT_NAME="SimpleStorage"
RPC=$RPC_URL_MUMBAI


forge create --rpc-url $RPC \
--private-key $PRIVATE_KEY \
--etherscan-api-key $ETHERSCAN_POLYGON_KEY \
--verify \
$CONTRACT_SRC:$CONTRACT_NAME
