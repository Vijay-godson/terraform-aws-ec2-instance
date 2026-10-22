terradorm{
  required_providers{
    aws={
      source = "hashicorp/aws"
      version = "~ 5.0"
    }
  }
}

provider "aws"{
  region=var.region
}

resource "aws_key_pair" "deployer"{
  key_name="${var.instance_name}-key"
  public_key=file("${path.module}/id_rsa.pub)"
}

resource "aws_instance" "instance"{
 ami = var.ami
 instance_type = var.instance_type
 key_name=aws_key_pair.deployer.key_name
  tags{
  Name=var.instance_name
 } 
}

output "instance_public_ip"{
  value= aws_instance.instance.public_ip
  description = "this is the public ip of the instance ${ var.instance_name }"
}
