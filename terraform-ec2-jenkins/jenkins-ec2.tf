resource "aws_instance" "jenkins_server" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = "${var.key_pair_name}"

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name = "JenkinsServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update the package index
              sudo yum update -y

              # Install Docker
              sudo yum install -y docker

              # Start Docker service
              sudo service docker start

              # Add ec2-user to the docker group
              sudo usermod -a -G docker ec2-user

              # Pull the Jenkins Docker image
              sudo docker pull jenkins/jenkins:lts

              # Create a Jenkins directory for persistent storage
              sudo mkdir -p /var/jenkins_home
              sudo chown -R 1000:1000 /var/jenkins_home

              # Run Jenkins in a Docker container
              sudo docker run -d -p 8080:8080 -p 50000:50000 \
                --name jenkins \
                -v /var/jenkins_home:/var/jenkins_home \
                jenkins/jenkins:lts
              EOF
}
