resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [var.subnets]

  tags = {
    Name = "DBSubnetGroup"
  }
}

resource "aws_db_instance" "database" {
  multi_az                    = true                # Enables Multi-AZ deployment
  identifier                  = "my-database"  
  allocated_storage           = 20                  # storage size (in GB) 
  engine                      = "mysql"             # Specifies the database (MySQL in this case).
  engine_version              = "8.0"               # version of MySQL engine.
  instance_class              = "db.t2.micro"       # instance type
  db_name                     = "mydb"              # name of the database
  username                    = "admin"             # username for database
  password                    = "securepassword"  
  parameter_group_name        = "default.mysql8.0"  # Assigns the default parameter group for MySQL 8.0.
  vpc_security_group_ids      = var.db_sg  
  db_subnet_group_name        = aws_db_subnet_group.db_subnet_group.name  
  skip_final_snapshot         = true                #Skips taking a snapshot when db instance deleted.
  backup_retention_period     = 7                   # Retains automated backups for 7 days. If set to 0, no backups are kept.
  backup_window               = "04:00-05:00"    
  storage_encrypted           = true                # Enables encryption for the RDS storage.

  tags = {
    Name = "MyDatabase" 
  }
}

resource "aws_security_group_rule" "allow_app_to_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.db_sg      # DB security group
  source_security_group_id = var.app_sg  # App security group
}

resource "aws_db_instance" "replica" {
  identifier              = "replica-db-instance"
  allocated_storage       = 20
  engine                  = aws_db_instance.database.engine
  engine_version          = aws_db_instance.database.engine_version
  instance_class          = "db.t3.micro"
  replicate_source_db     = aws_db_instance.database.id 
  vpc_security_group_ids  = var.db_sg
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_db_snapshot" "manual_snapshot" {
  db_instance_identifier = aws_db_instance.database.id      # Specifies the DB instance to take the snapshot of.
  db_snapshot_identifier = "manual-snapshot-$(timestamp())" # Generates a unique snapshot identifier based on the timestamp.
}

output "db_endpoint" {
  value       = aws_db_instance.database.endpoint
  description = "Database endpoint"
}
