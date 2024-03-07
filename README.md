# pp_webserver

## commands

### docker

```bash
cat /proc/sys/kernel/keys/maxkeys

cat /proc/sys/kernel/keys/root_maxkeys

cat /proc/keys | wc -l
```
### puppet

```bash
pdk new module webserver

cd webserver

pdk new class webserver

pdk validate

pdk test unit --parallel

pdk bundle exec rake 'litmus:provision[docker, litmusimage/redhat:8]'

pdk bundle exec rake 'litmus:provision[docker, litmusimage/redhat:9]'

pdk bundle exec rake 'litmus:provision[docker, litmusimage/centos:stream8]'

pdk bundle exec rake 'litmus:provision[docker, litmusimage/centos:stream9]'

pdk bundle exec rake 'litmus:provision[docker, litmusimage/ubuntu:20.04]'

pdk bundle exec rake 'litmus:provision[docker, litmusimage/ubuntu:22.04]'

pdk bundle exec rake 'litmus:provision[docker, litmusimage/ubuntu:24.04]'

pdk bundle exec rake litmus:provision_list[docker-dnf]

pdk bundle exec rake litmus:install_agent[puppet8]

bolt command run 'puppet --version' --targets localhost:2222 --inventoryfile spec/fixtures/litmus_inventory.yaml

pdk bundle exec rake litmus:install_module

bolt command run 'puppet module list' --targets localhost:2222 -i spec/fixtures/litmus_inventory.yaml

bolt command run 'cat /etc/nginx/nginx.conf' --targets localhost:2222 -i spec/fixtures/litmus_inventory.yaml

bolt command run 'cat /etc/nginx/sites-enabled/example.com.conf' --targets localhost:2222 -i spec/fixtures/litmus_inventory.yaml

bolt command run 'cat /etc/nginx/sites-enabled/nginx_status.conf' --targets localhost:2222 -i spec/fixtures/litmus_inventory.yaml

bolt command run 'cat /etc/nginx/sites-available/example.com.conf' --targets localhost:2222 -i spec/fixtures/litmus_inventory.yaml

bolt command run 'cat /etc/nginx/sites-available/nginx_status.conf' --targets localhost:2222 -i spec/fixtures/litmus_inventory.yaml

bolt command run 'ls /etc/nginx/sites-enabled' --targets localhost:2222 -i spec/fixtures/litmus_inventory.yaml

pdk bundle exec rake litmus:acceptance:parallel

pdk bundle exec rake litmus:tear_down
```
