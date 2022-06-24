## Azure CLI setup
### Setup

Azure CLI installation steps can be found in the [documentation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) 

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
### Login
```
az login
```
Use your browser to log into Azure

```
az account show
```

## Create a service principal

Next, create a service principal with the role "Contributor"
The Contributor role is [described](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) as "Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC, manage assignments in Azure Blueprints, or share image galleries."
```.

SUBSCRIPTION_ID=$(az account show | jq -r .id)
az ad sp create-for-rbac \
    --role="Contributor" \
    --scopes="/subscriptions/${SUBSCRIPTION_ID}" \
    -n "terraform" > tf-principal.json
```

(Optional) To view the newly created principal in the browser, navigate to `Active Directory`->`Registered Applications`->`All applications`
(Optional) List the newly created principal using the CLI
```
az ad sp list --display-name terraform
```
## Log in using service principal
```
az login --service-principal \
    -u "$(jq -r .appId tf-principal.json)" \
    -p "$(jq -r .password tf-principal.json)" \
    --tenant "$(jq -r .tenant tf-principal.json)"
```

View current status
```
az account show
```

## Export environment variables for Terraform
The following environment variables as described in the [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#configuring-the-service-principal-in-terraform)
```
export ARM_CLIENT_ID=$(jq -r .appId tf-principal.json)
export ARM_TENANT_ID=$(jq -r .tenant tf-principal.json)
export ARM_SUBSCRIPTION_ID=$(az account show | jq -r .id)
export ARM_CLIENT_SECRET=$(jq -r .password tf-principal.json)
```

## Ready to go
If everything is set up correctly, running `terraform plan` on a valid Azure configuration should be successful.
The four `ARM_*` variables must be set before running terraform commands.

## (Optional) Remote backend - Azure Resource Manager
[Azure RM](https://www.terraform.io/docs/language/settings/backends/azurerm.html) is one of the backends supported by Terraform.
What I've done is - created a resource group called `state`

In this resource group, create a storage account(with a globally unique name), and in this storage account create a container named `tfstate`.

Copy the template, and edit it
```
cp arm-backend.tf.template resource-manager/arm-backend.tf
# Edit the file to match your resource names
```