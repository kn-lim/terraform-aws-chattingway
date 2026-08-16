module "counter_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "5.5.1"

  create_table = var.enable_counter_table

  name         = "${var.name}-counters"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "guild_id"
  range_key    = "name"

  attributes = [
    {
      name = "guild_id"
      type = "S"
    },
    {
      name = "name"
      type = "S"
    },
  ]

  tags = var.tags
}
