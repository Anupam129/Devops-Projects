provider "aws" {
  region     = "ap-southeast-2"
  access_key = "AKIAXEZ6JST5DgYN6DGZ"
  secret_key = "ZhWe0GKwBQ54DGuuR6Czm5eaaDkjAr63jVb5abvq"
}

resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "AmazonVPC"
  }
}




