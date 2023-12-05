#create a RDS Database Instance
resource "aws_db_instance" "my_db" {
  engine                      = "mysql"
  storage_type                = "gp2"
  identifier                  = "myrdsinstance"
  allocated_storage           = 20
  db_name                     = var.db_name
  engine_version              = "5.7"
  instance_class              = "db.t2.micro"
  username                    = var.db_username
  password                    = var.db_password
  parameter_group_name        = "default.mysql5.7"
  backup_retention_period     = 7

  db_subnet_group_name        = aws_db_subnet_group.db_subnet_group.name

  allow_major_version_upgrade = true

  auto_minor_version_upgrade  = true
  backup_window               = "02:00-03:00"
  maintenance_window          = "Sat:03:00-Sat:06:00"

  vpc_security_group_ids = [
    var.rds_sg_id
  ]

  multi_az                    = true
  skip_final_snapshot         = true
  publicly_accessible         = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [var.private_us_east_1a_id, var.private_us_east_1b_id]

  tags = {
    Name = "db-subnet-group"
  }
}