resource "aws_ami_copy" "amiBaseWP" {
  name              = "${join("-", ["amiBaseWP", var.aws_region])}"
  description       = "A copy of ami-0f4f7815ff0371a84"
  source_ami_id     = "ami-0f4f7815ff0371a84"
  source_ami_region = "us-west-2"

  tags = {
    Name = "amiBaseWP"
  }
}

data "template_file" "script" {
  template = file("/home/czorn/desafioTF/ScriptWordpress.sh")
  vars = {efs_id = aws_efs_file_system.EFSG4.id}
}

resource "aws_launch_configuration" "ASConfignG4" {
  name_prefix     = "Grupo4"
  image_id        = aws_ami_copy.amiBaseWP.id
  instance_type   = var.InstanceType
  security_groups = [aws_security_group.SGInstancias.id]

  user_data = data.template_file.script.rendered
  associate_public_ip_address = true
  depends_on = [aws_efs_file_system.EFSG4]

  # O recurso LaunchConfiguration não pode ser modificado após o
  # seu deploy. Então em uma modificação o Terraform irá destruir para 
  # construir com a modificação, fazendo com que o app fique temporariamente fora.
  # Porém se create_before_destroy = true, ele irá criar um novo autoscaling 
  # antes de destruir o antigo, evitando a interrupção.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "G4-LauchTemplate" {
  name = "Grupo4LauchTamplate"

  block_device_mappings {
    ebs {
      volume_size = 20
    }
  }

  image_id                             = aws_ami_copy.amiBaseWP.id #var.AMIType
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  vpc_security_group_ids               = [aws_security_group.SGInstancias.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Grupo4LauchTamplate"
    }
  }

  user_data = filebase64("/home/czorn/desafioTF/ScriptWordpress.sh")
}

resource "aws_autoscaling_group" "ASG4" {
  name                      = "ASGG4"
  max_size                  = 6
  min_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true

  launch_configuration = aws_launch_configuration.ASConfignG4.name
  vpc_zone_identifier  = aws_subnet.Public.*.id
  target_group_arns    = ["${aws_lb_target_group.alb_target_group.arn}"]
  metrics_granularity= "1Minute"
  depends_on = [aws_security_group.LiberaTudo, aws_launch_configuration.ASConfignG4 ]

  wait_for_capacity_timeout = 0

  initial_lifecycle_hook {
    name                 = "G4"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }
  tag {
    key                 = "ASG"
    value               = "G4"
    propagate_at_launch = true
  }

  tag {
    key                 = "EFS_ID"
    value               = aws_efs_file_system.EFSG4.id
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_autoscaling_policy" "G4" {
  name                   = "Desafio2G4"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ASG4.name
  policy_type            = "SimpleScaling"
}

