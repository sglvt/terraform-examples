# Azure CLI setup
## Setup
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux
For Debian/Ubuntu:
```
curl -sL https://aka.ms/InstallAzureCLIDeb > az-cli-setup.sh
# have a quick look at the script you just downloaded
less az-cli-setup.sh
chmod +x az-cli-setup.sh
sudo ./az-cli-setup.sh
```
Check the version
```
az version
```
## Login
```
az login
```
Use your browser to log into Azure

```
az account show
```

# Create a service principal
```
SUBSCRIPTION_ID=$(az account show | jq -r .id)
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
```