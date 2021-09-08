# Github

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
