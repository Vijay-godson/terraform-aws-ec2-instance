resource "aws_key_pair" "deployer"{
  key_name="${var.instance_name}-key"
  public_key=file("${path.module}/id_rsa.pub")
}

resource "aws_instance" "instance"{
 ami = var.ami
 instance_type = var.instance_type
 key_name=aws_key_pair.deployer.key_name
  tags{
  Name=var.instance_name
 } 
}
