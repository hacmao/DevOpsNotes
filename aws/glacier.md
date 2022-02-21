Restore glacier to standard:  

```
BUCKET=<BUCKET_NAME>
PROFILE=<ROLE_NAME>
aws s3api list-objects --bucket $BUCKET --profile $PROFILE | jq '.Contents[] | select(.StorageClass == "GLACIER") | .Key' | xargs -P 10 -L 1 aws s3api restore-object --bucket $BUCKET --profile $PROFILE --restore-request '{"Days":30,"GlacierJobParameters":{"Tier":"Standard"}}' --key
aws s3api list-objects --bucket $BUCKET --profile $PROFILE | jq '.Contents[] | select(.StorageClass == "GLACIER") | .Key'  | xargs -P 10 -L 1 -I{} aws s3api copy-object --bucket $BUCKET --copy-source "$BUCKET/{}" --metadata-directive REPLACE --profile $PROFILE --key {}
```
