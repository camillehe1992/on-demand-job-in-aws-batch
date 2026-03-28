resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.public_subnet_ids[0]

  tags = merge(var.tags, {
    "Name" = "${local.resource_prefix}-nat"
  })
}

data "aws_route_table" "private" {
  vpc_id = var.vpc_id

  # filter by tag Type=private
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

resource "aws_route" "to_nat" {
  route_table_id         = data.aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

resource "aws_batch_compute_environment" "compute_environment" {
  name = "${local.resource_prefix}-ce"

  compute_resources {
    instance_type = var.instance_types
    instance_role = local.batch_instance_role_profile_arn

    max_vcpus     = var.max_vcpus
    min_vcpus     = var.min_vcpus
    desired_vcpus = var.desired_vcpus

    subnets            = var.private_subnet_ids
    security_group_ids = var.security_group_ids

    type                = "EC2"
    spot_iam_fleet_role = null # Configure Spot IAM Fleet Role if using Spot Instances
  }

  service_role = local.aws_batch_service_role_arn
  type         = "MANAGED"

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      compute_resources[0].desired_vcpus, # Allow auto scaling
    ]
  }

  tags = var.tags
}
