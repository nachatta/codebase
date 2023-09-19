location = "canadacentral"

resource_prefixes = ["shared", "prod"]

tags = {
  environment = "production"
  owner       = "maxime.dupras@gsoft.com"
  costCenter  = "sharegate"
  department  = "sharegate"
}

cert_readers_object_ids = [
  "d0485e69-10c3-45a4-b293-e4c60a0519de", # sg-gravt-prod-cluster-guydm0x2emdzz-agentpool
  "63011fab-f4f6-46d3-a058-c70fc7f56e74", # sgd-svc-prod-cluster-1c7dsihmftuwx-agentpool
  "fa0472ed-02e7-4a64-8377-57fb29c13c5a"  # sg-one-prod-cluster-0ozofct6hu7x2-agentpool
]
