# Prerequisites
Download `doctl` https://github.com/digitalocean/doctl#downloading-a-release-from-github
```
doctl auth init
echo 'export DIGITALOCEAN_TOKEN=$(cat ~/.config/doctl/config.yaml | grep token| cut -f2 -d" ")' >> ~/.bashrc
```
Switch to one of the examples
E.g.
```
cd ~/vpc
```
Copy and edit `do-backend.tf.template`
```
cp ../do-backend.tf.template do-backend.tf
# edit do-backend.tf
```
Initialize working directory
```
terraform init \
-backend-config="access_key=$SPACES_ACCESS_TOKEN" \
-backend-config="secret_key=$SPACES_SECRET_KEY"
```