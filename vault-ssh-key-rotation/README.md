# HashiCorp Vault SSH Implementation

This guide provides instructions for configuring a remote host and client host to use HashiCorp Vault for SSH authentication.

## Configurations on Remote Host

1. **Get Vault Public Key using API call:**

    ```bash
    curl 'https://<vault-url>/v1/ssh-client-signer/public_key' > /etc/ssh/trusted-CA-key.pem
    ```

2. **Configure the SSHD service to trust the certificates signed by Vault CA:**

    ```bash
    echo "TrustedUserCAKeys /etc/ssh/trusted-CA-key.pem" >> /etc/ssh/sshd_config
    ```

3. **Restart the SSH service:**

    ```bash
    systemctl restart sshd
    ```

## Configurations on Client Host

Clone the file `vault_ssh.sh` on your client host:

### Usage

1. **Ensure you have `jq` installed on your client host. If not, install it using:**

    ```bash
    sudo apt-get install jq
    sudo yum install jq
    ```

2. **Make the script executable:**

    ```bash
    chmod +x vault_ssh.sh
    ```

3. **Run the script, providing your LDAP password as an argument:**

    ```bash
    ./vault_ssh.sh <LDAP_PASSWORD>
    ```

### Example

```bash
./vault_ssh.sh MySecretPassword
```

This script will:

- Authenticate with Vault using your LDAP credentials.
- Retrieve a Vault token.
- Use the token to sign a auto generated SSH private key.
- Save the signed key and the private key locally.
- Use the keys to log in to the remote host.

## Prerequisites

- Ensure the remote host is configured to trust certificates signed by Vault CA.
- Ensure `jq` is installed on the client host.

## Notes

- Update `<vault-url>`, `vault-role`, `remote-server-user`, `remote-host`, and `username` with your actual values.
- The signed certificate's Time To Live (TTL) is set to 2 minutes. Adjust `CRT_EXPIRY_TIME` as needed.