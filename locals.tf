locals {
  regions_data = jsondecode(file("region-selection.json"))
}

/*
> region-selection.json contains the following json document:

```json
{
    "us-east-1": 0,
    "us-east-2": 2,
    "us-west-1": 2,
    "us-west-2": 0
}
```
*/