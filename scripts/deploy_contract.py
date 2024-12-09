from web3 import Web3
import json
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

INFURA_URL = f"{os.getenv('INFURA_PROJECT_ID')}"
PRIVATE_KEY = os.getenv("PRIVATE_KEY")
ACCOUNT_ADDRESS = os.getenv("ACCOUNT_ADDRESS")

# Load ABI and bytecode
with open("./scripts/abi.json", "r") as file:
    abi = json.load(file)

with open("./scripts/bytecode.json", "r") as file:
    bytecode = json.load(file)

# Connect to Web3
web3 = Web3(Web3.HTTPProvider(INFURA_URL))

# Ensure connection is established
if not web3.is_connected():
    raise Exception("Failed to connect to Ethereum network")

# Get the nonce for the account
nonce = web3.eth.get_transaction_count(ACCOUNT_ADDRESS)

# Deploy the contract
contract = web3.eth.contract(abi=abi, bytecode=bytecode)
transaction = contract.constructor().build_transaction({
    "from": ACCOUNT_ADDRESS,
    "nonce": nonce,
    "gas": 2000000,
    "gasPrice": web3.to_wei("20", "gwei")
})

# Sign the transaction
signed_tx = web3.eth.account.sign_transaction(transaction, PRIVATE_KEY)

# Send the transaction
tx_hash = web3.eth.send_raw_transaction(signed_tx.raw_transaction)

# Wait for the transaction to be mined
tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)

# Save contract address to a file
contract_address = tx_receipt.contractAddress
print(f"Contract deployed at address: {contract_address}")

# Save the contract address to a JSON file
address_file = "./scripts/contract_address.json"
with open(address_file, "w") as file:
    json.dump({"contract_address": contract_address}, file, indent=4)

print(f"Contract address saved to {address_file}")
