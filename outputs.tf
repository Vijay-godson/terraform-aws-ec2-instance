output "instance_public_ip"{
  value= aws_instance.instance.public_ip
  description = "this is the public ip of the instance ${ var.instance_name }"
}
