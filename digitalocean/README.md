# Prerequisites
Download `doctl` https://github.com/digitalocean/doctl#downloading-a-release-from-github
```
doctl auth init
echo 'export DIGITALOCEAN_TOKEN=$(cat ~/.config/doctl/config.yaml | grep token| cut -f2 -d" ")' >> ~/.bashrc
```
Initialize working directory
```
terraform init \
-backend-config="access_key=$SPACES_ACCESS_TOKEN" \
-backend-config="secret_key=$SPACES_SECRET_KEY"
```