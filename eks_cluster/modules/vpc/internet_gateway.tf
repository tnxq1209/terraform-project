#Internet Gate Way
resource "aws_internet_gateway" "proj_igw" {
  vpc_id = local.vpc_id
  tags = merge(
    var.common_tags,
    {
      Name = "${var.common_tags.Project}-igw"
    }
  )
}