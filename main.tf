provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "foo" {
  ami           = "ami-0f9de6e2d2f067fca" # us-west-2
  instance_type = "t2.micro"
  tags = {
      Name = "Bhargava_Ram"
  }
}
