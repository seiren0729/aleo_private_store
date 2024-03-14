APPNAME="store_seiren"

ENV_FILE=".env"
PRIVATE_KEY=$(grep "PRIVATE_KEY" $ENV_FILE | cut -d '=' -f2)

TOKEN="{ 
    owner: aleo1jnc0zu0jmttwlullcjcneww5ck37znj3ut97rye47g87cn9k7vqsvvcqq4.private,
    amount: 10000u64.private,
    _nonce: 4219436364331187995166368995208606759359349331420867521633397203901277532802group.public 
}"

snarkos developer execute "${APPNAME}.aleo" buy \
  "${TOKEN}" \
  1u8 \
  5u64 \
  500u64 \
  --private-key "${PRIVATE_KEY}" \
  --query "https://api.explorer.aleo.org/v1" \
  --priority-fee 3000000 \
  --broadcast "https://api.explorer.aleo.org/v1/testnet3/transaction/broadcast" \