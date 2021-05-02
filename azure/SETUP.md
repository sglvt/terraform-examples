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

Next, create a service principal with the role "Contributor"
The Contributor role is [described](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) as "Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries."
```.

SUBSCRIPTION_ID=$(az account show | jq -r .id)
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}" -n "terraform" > tf-principal.json
```

(Optional) To view the newly created principal in the browser, navigate to `Active Directory`->`Registered Applications`->`All applications`
(Optional) List the newly created principal using the CLI
```
az ad sp list --display-name terraform
```