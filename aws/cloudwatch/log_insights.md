```
fields @message,@log
| filter @message like /WARN/
| fields strcontains(@log, "admin") as admin
| fields strcontains(@log, "monitor") as monitor
| fields strcontains(@log, "saas") as saas
| fields strcontains(@log, "event") as event
| fields strcontains(@log, "setup") as setup
| fields strcontains(@log, "loop") as loop_batch
| stats  sum(admin) as sips_admin_api, sum(setup) as sips_baseunit_setup_api, sum(monitor) as sips_monitor_api, 
sum(saas) as sips_saas_api, sum(event) as sips_baseunit_event_api, sum(loop_batch) as sips_loop_batch_api by bin(15m) 

```
