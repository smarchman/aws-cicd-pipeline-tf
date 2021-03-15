resource "aws_vpc" "deleteme" {
    cidr_block = "10.222.0.0/16"
    tags = {
      "Name" = "Delete this sumbitch"
    }
  
}