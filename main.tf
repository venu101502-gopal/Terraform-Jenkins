provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "venugopal" {
  ami                         = "ami-053b0d53c279acc90"  # Ubuntu 22.04 LTS
  instance_type               = "t2.micro"
  key_name                    = "Blue-key"
  subnet_id                   = "subnet-0d1fa72421efd7af5"
  vpc_security_group_ids      = ["sg-054788bd6d2edbc82"]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  dynamic "ebs_block_device" {
    for_each = {
      "/dev/xvdf" = 10,
      "/dev/xvdg" = 20,
      "/dev/xvdh" = 30
    }

    content {
      device_name           = ebs_block_device.key
      volume_size           = ebs_block_device.value
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }

  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1

    # Format volumes
    mkfs.xfs -f /dev/xvdf
    mkfs.xfs -f /dev/xvdg
    mkfs.xfs -f /dev/xvdh

    # Create mount points
    mkdir -p /home/ibtbackup /opt/sutisoftapps /var/lib/mysql

    # Mount volumes
    mount /dev/xvdf /home/ibtbackup
    mount /dev/xvdg /opt/sutisoftapps
    mount /dev/xvdh /var/lib/mysql

    # Persist mounts
    echo "UUID=$(blkid -s UUID -o value /dev/xvdf) /home/ibtbackup xfs defaults,nofail 0 2" >> /etc/fstab
    echo "UUID=$(blkid -s UUID -o value /dev/xvdg) /opt/sutisoftapps xfs defaults,nofail 0 2" >> /etc/fstab
    echo "UUID=$(blkid -s UUID -o value /dev/xvdh) /var/lib/mysql xfs defaults,nofail 0 2" >> /etc/fstab
  EOF

  tags = {
    Name = "Bhrgava_Ram"
  }
}

output "venugopal_public_ip" {
  value = aws_instance.venugopal.public_ip
}

output "venugopal_private_ip" {
  value = aws_instance.venugopal.private_ip
}

output "venugopal_key_name" {
  value = aws_instance.venugopal.key_name
}
