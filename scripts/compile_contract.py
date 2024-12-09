from solcx import compile_standard, install_solc
import json
import os

# Install the Solidity compiler
install_solc("0.8.0")

# Paths
contract_path = "./contracts/GestionnaireRisqueContrepartie.sol"
abi_path = "./scripts/abi.json"
bytecode_path = "./scripts/bytecode.json"

# Load contract
with open(contract_path, "r") as file:
    contract_source = file.read()

# Compile contract
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"GestionnaireRisqueContrepartie.sol": {"content": contract_source}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "evm.bytecode.object"]
                }
            }
        },
    },
    solc_version="0.8.0",
)

# Extract ABI and bytecode
abi = compiled_sol["contracts"]["GestionnaireRisqueContrepartie.sol"]["GestionnaireRisqueContrepartie"]["abi"]
bytecode = compiled_sol["contracts"]["GestionnaireRisqueContrepartie.sol"]["GestionnaireRisqueContrepartie"]["evm"]["bytecode"]["object"]

# Save ABI and bytecode
with open(abi_path, "w") as file:
    json.dump(abi, file)

with open(bytecode_path, "w") as file:
    json.dump(bytecode, file)

print(f"ABI saved to {abi_path}")
print(f"Bytecode saved to {bytecode_path}")
