# This script is used to deploy and configure an ICRC token canister on the Internet Computer network.
# Ensure you have dfx (the DFINITY Canister SDK) installed and configured before running this script.

# Exit immediately if a command exits with a non-zero status, and print each command.
set -ex

# --- Configuration Section ---

# Identity configuration. Replace '{production_identity}' with your production identity name. This identity needs to be a controller for your canister
PRODUCTION_IDENTITY="{production_identity}"
dfx identity use $PRODUCTION_IDENTITY

# Canister identitfication - You need to create this canister either via dfx or throught the nns console
PRODUCTION_CANISTER="{production_canister}"

#check your cycles. The system needs at least 2x the archiveCycles below to create the archive canister.  We suggest funding the initial canister with 4x the cycles configured in archiveCycles and then using a tool like cycle ops to monitor your cycles. You will need to add the created archive canisters(created after the first maxActiveRecords are created) to cycleops manually for it to be monitored.



# Token configuration
TOKEN_NAME="Waste2Earn"
TOKEN_SYMBOL="Waste"
TOKEN_LOGO="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAEbGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4KPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLyc+CjxyZGY6UkRGIHhtbG5zOnJkZj0naHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyc+CgogPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICB4bWxuczpBdHRyaWI9J2h0dHA6Ly9ucy5hdHRyaWJ1dGlvbi5jb20vYWRzLzEuMC8nPgogIDxBdHRyaWI6QWRzPgogICA8cmRmOlNlcT4KICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0nUmVzb3VyY2UnPgogICAgIDxBdHRyaWI6Q3JlYXRlZD4yMDI0LTExLTE5PC9BdHRyaWI6Q3JlYXRlZD4KICAgICA8QXR0cmliOkV4dElkPjE8L0F0dHJpYjpFeHRJZD4KICAgICA8QXR0cmliOkZiSWQ+NTI1MjY1OTE0MTc5NTgwPC9BdHRyaWI6RmJJZD4KICAgICA8QXR0cmliOlRvdWNoVHlwZT4yPC9BdHRyaWI6VG91Y2hUeXBlPgogICAgPC9yZGY6bGk+CiAgIDwvcmRmOlNlcT4KICA8L0F0dHJpYjpBZHM+CiA8L3JkZjpEZXNjcmlwdGlvbj4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nJwogIHhtbG5zOmRjPSdodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyc+CiAgPGRjOnRpdGxlPgogICA8cmRmOkFsdD4KICAgIDxyZGY6bGkgeG1sOmxhbmc9J3gtZGVmYXVsdCc+VzJFTiAtIDE8L3JkZjpsaT4KICAgPC9yZGY6QWx0PgogIDwvZGM6dGl0bGU+CiA8L3JkZjpEZXNjcmlwdGlvbj4KCiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nJwogIHhtbG5zOnBkZj0naHR0cDovL25zLmFkb2JlLmNv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"
TOKEN_DECIMALS=8
TOKEN_FEE=10000
MAX_SUPPLY=null
MIN_BURN_AMOUNT=10000
MAX_MEMO=64
MAX_ACCOUNTS=1000000000
SETTLE_TO_ACCOUNTS=99999000

# Automatically fetches the principal ID of the currently used identity.
ADMIN_PRINCIPAL=$(dfx identity get-principal)

# --- Deployment Section ---

dfx build --network ic token --check

# Deploy the canister with the specified configuration.
dfx canister --network ic install --mode install --wasm .dfx/ic/canisters/prodtoken/prodtoken.wasm.gz --argument "(opt record {icrc1 = opt record {
  name = opt \"$TOKEN_NAME\";
  symbol = opt \"$TOKEN_SYMBOL\";
  logo = opt \"$TOKEN_LOGO\";
  decimals = $TOKEN_DECIMALS;
  fee = opt variant { Fixed = $TOKEN_FEE};
  minting_account = opt record{
    owner = principal \"$ADMIN_PRINCIPAL\";
    subaccount = null;
  };
  max_supply = $MAX_SUPPLY;
  min_burn_amount = opt $MIN_BURN_AMOUNT;
  max_memo = opt $MAX_MEMO;
  advanced_settings = null;
  metadata = null;
  fee_collector = null;
  transaction_window = null;
  permitted_drift = null;
  max_accounts = opt $MAX_ACCOUNTS;
  settle_to_accounts = opt $SETTLE_TO_ACCOUNTS;
}; 
icrc2 = opt record{
  max_approvals_per_account = opt 10000;
  max_allowance = opt variant { TotalSupply = null};
  fee = opt variant { ICRC1 = null};
  advanced_settings = null;
  max_approvals = opt 10000000;
  settle_to_approvals = opt 9990000;
}; 
icrc3 = opt record {
  maxActiveRecords = 3000;
  settleToRecords = 2000;
  maxRecordsInArchiveInstance = 100000000;
  maxArchivePages = 62500;
  archiveIndexType = variant {Stable = null};
  maxRecordsToArchive = 8000;
  archiveCycles = 6_000_000_000_000;
  supportedBlocks = vec {};
  archiveControllers = null;
};
icrc4 = opt record {
  max_balances = opt 200;
  max_transfers = opt 200;
  fee = opt variant { ICRC1 = null};
};})"

# Fetch the canister ID after deployment
ICRC_CANISTER=$(dfx canister id token)

# Output the canister ID
echo $ICRC_CANISTER

# --- Initialization and Query Section ---

# Initialize the admin configuration of the token canister
dfx canister call token admin_init

# Fetch and display various token details like name, symbol, decimals, fee, and metadata
dfx canister call token icrc1_name  --query 
dfx canister call token icrc1_symbol  --query 
dfx canister call token icrc1_decimals  --query 
dfx canister call token icrc1_fee  --query 
dfx canister call token icrc1_metadata  --query 
