# Github

## Github multiple key  

Configure ssh config :  

```bash
# Default github account: oanhnn
Host github.com
   HostName github.com
   IdentityFile ~/.ssh/oanhnn_private_key
   IdentitiesOnly yes
   
# Other github account: superman
Host github-superman
   HostName github.com
   IdentityFile ~/.ssh/superman_private_key
   IdentitiesOnly yes
```

## Github action

### Event and payloads

[Document](https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads)

### Print object properties

```yaml
- name: test
  run: |
    echo "${{ toJson(github) }}"
    echo "${{ toJson(github.event) }}"
```

