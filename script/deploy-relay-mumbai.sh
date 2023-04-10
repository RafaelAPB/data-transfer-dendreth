set -e
source .env

CONTRACT_SRC="src/RelayContract.sol"
CONTRACT_NAME="RelayContract"
RPC=$RPC_URL_MUMBAI


forge create --rpc-url $RPC \
--private-key $PRIVATE_KEY \
--etherscan-api-key $ETHERSCAN_POLYGON_KEY \
--verify \
$CONTRACT_SRC:$CONTRACT_NAME
