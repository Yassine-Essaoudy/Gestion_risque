import json
from web3 import Web3
import streamlit as st
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

INFURA_URL = f"{os.getenv('INFURA_PROJECT_ID')}"

# Load ABI
with open("./scripts/abi.json", "r") as file:
    abi = json.load(file)

# Load contract address from file
with open("./scripts/contract_address.json", "r") as file:
    contract_data = json.load(file)
CONTRACT_ADDRESS = contract_data["contract_address"]

# Connect to Web3
web3 = Web3(Web3.HTTPProvider(INFURA_URL))

# Load contract
contract = web3.eth.contract(address=CONTRACT_ADDRESS, abi=abi)

# Streamlit App Code (same as before)
# Streamlit App
st.title("Gestionnaire Risque Contrepartie")

# Sidebar: Select an action
action = st.sidebar.selectbox(
    "Select Action",
    ["Add Counterparty", "Add Position", "Get Counterparty Details", "Get Positions", "Calculate Risk Score"]
)

# Functions for each action
def add_counterparty():
    address = st.text_input("Counterparty Address")
    credit_score = st.number_input("Credit Score", min_value=0)
    exposure_limit = st.number_input("Exposure Limit", min_value=0)
    if st.button("Submit"):
        tx = contract.functions.ajouterContrepartie(address, credit_score, exposure_limit).call()
        st.success(f"Transaction hash: {tx}")

def add_position():
    initiater = st.text_input("Initiater Address")
    counterparty = st.text_input("Counterparty Address")
    amount = st.number_input("Amount", min_value=0)
    collateral = st.number_input("Collateral", min_value=0)
    if st.button("Submit"):
        tx = contract.functions.ajouterPosition(initiater, counterparty, amount, collateral).call()
        st.success(f"Transaction hash: {tx}")

# Handle actions
if action == "Add Counterparty":
    add_counterparty()
elif action == "Add Position":
    add_position()