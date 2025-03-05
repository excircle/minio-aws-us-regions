#------------------------------------------------------------------------------
# VPCS
#------------------------------------------------------------------------------

////////////
// East 1 //
////////////

module "minio-vpc-east-1" {
  count = local.regions_data["us-east-1"] > 0 ? 1 : 0
  source = "github.com/excircle/tf-aws-minio-vpc"
  providers = {
    aws = aws.us-east-1
  }

  application_name      = "minio-vpc-east-1"
  az_count              = 2
  make_private          = false
  createdby_tag         = "Terraform"
  owner_tag             = "AlexanderKalaj"
  purpose_tag           = "minio-vpc-east-1"
}

////////////
// East 2 //
////////////

module "minio-vpc-east-2" {
  count = local.regions_data["us-east-2"] > 0 ? 1 : 0
  source = "github.com/excircle/tf-aws-minio-vpc"
  providers = {
    aws = aws.us-east-2
  }

  application_name      = "minio-vpc-east-2"
  az_count              = 2
  make_private          = false
  createdby_tag         = "Terraform"
  owner_tag             = "AlexanderKalaj"
  purpose_tag           = "minio-vpc-east-2"
}

////////////
// West 1 //
////////////

module "minio-vpc-west-1" {
  count = local.regions_data["us-west-1"] > 0 ? 1 : 0
  source = "github.com/excircle/tf-aws-minio-vpc"
  providers = {
    aws = aws.us-west-1
  }

  application_name      = "minio-vpc-west-1"
  az_count              = 2
  make_private          = false
  createdby_tag         = "Terraform"
  owner_tag             = "AlexanderKalaj"
  purpose_tag           = "minio-vpc-west-1"
}

////////////
// West 2 //
////////////

module "minio-vpc-west-2" {
  count = local.regions_data["us-west-2"] > 0 ? 1 : 0
  source = "github.com/excircle/tf-aws-minio-vpc"
  providers = {
    aws = aws.us-west-2
  }

  application_name      = "minio-vpc-west-2"
  az_count              = 2
  make_private          = false
  createdby_tag         = "Terraform"
  owner_tag             = "AlexanderKalaj"
  purpose_tag           = "minio-vpc-west-2"
}

#------------------------------------------------------------------------------
# MinIO Clusters
#------------------------------------------------------------------------------

///////////////////////
// East 1 Cluster(s) //
///////////////////////

module "minio-east-1-cluster1" {
  for_each = toset([for i in range(local.regions_data["us-east-1"]) : tostring(i+1) ])
  source = "github.com/excircle/tf-aws-minio-cluster"
  providers = {
    aws = aws.us-east-1
  }

  application_name          = format("minio-east-1-cluster%s", each.value)
  system_user               = "ubuntu"
  hosts                     = 4                              # Number of nodes with MinIO installed
  vpc_id                    = module.minio-vpc-east-1[0].vpc_id
  ebs_root_volume_size      = 10
  ebs_storage_volume_size   = 100
  make_private              = false
  ec2_instance_type         = "t2.medium"
  ec2_ami_image             = "ami-0e1bed4f06a3b463d"        # (ami-0e1bed4f06a3b463d) Ubuntu 22.04 - us-east-1
  az_count                  = 2                              # Number of AZs to use
  subnets                   = module.minio-vpc-east-1[0].subnets
  num_disks                 = 4                              # Creates a number of disks
  sshkey                    = var.sshkey                     # Use env variables | export TF_VAR_sshkey=$(cat ~/.ssh/your-key-name.pub)
  ec2_key_name              = "sshkey"
  package_manager           = "apt"
  bastion_host              = false
}

//////////////////////
// East 2 Cluster 1 //
//////////////////////

module "minio-east-2-cluster1" {
  for_each = toset([for i in range(local.regions_data["us-east-2"]) : tostring(i+1) ])
  source = "github.com/excircle/tf-aws-minio-cluster"
  providers = {
    aws = aws.us-east-2
  }

  application_name          = format("minio-east-2-cluster%s", each.value)
  system_user               = "ubuntu"
  hosts                     = 2                              # Number of nodes with MinIO installed
  vpc_id                    = module.minio-vpc-east-2[0].vpc_id
  minio_license             = var.minio_license                     # Required only if using: minio_flavor = "aistor"
  minio_flavor              = "server"
  minio_binary_version      = "minio.RELEASE.2024-03-03T17-50-39Z"  # Example: "minio.RELEASE.2025-01-17T05-24-29Z" or "latest"
  minio_binary_arch         = "linux-amd64"
  ebs_root_volume_size      = 10
  ebs_storage_volume_size   = 100
  make_private              = false
  ec2_instance_type         = "t2.medium"
  ec2_ami_image             = "ami-0884d2865dbe9de4b"        # (ami-0884d2865dbe9de4b) Ubuntu 22.04 - us-east-2
  az_count                  = 2                              # Number of AZs to use
  subnets                   = module.minio-vpc-east-2[0].subnets
  num_disks                 = 4                              # Creates a number of disks
  sshkey                    = var.sshkey                     # Use env variables | export TF_VAR_sshkey=$(cat ~/.ssh/your-key-name.pub)
  ec2_key_name              = "sshkey"
  package_manager           = "apt"
  bastion_host              = false
}


//////////////////////
// West 1 Cluster 1 //
//////////////////////

module "minio-west-1-cluster1" {
  for_each = toset([for i in range(local.regions_data["us-west-1"]) : tostring(i+1) ])
  source = "github.com/excircle/tf-aws-minio-cluster"
  providers = {
    aws = aws.us-west-1
  }

  application_name          = format("minio-west-1-cluster%s", each.value)
  system_user               = "ubuntu"
  hosts                     = 2                              # Number of nodes with MinIO installed
  vpc_id                    = module.minio-vpc-west-1[0].vpc_id
  minio_license             = var.minio_license                     # Required only if using: minio_flavor = "aistor"
  minio_flavor              = "server"
  minio_binary_version      = "minio.RELEASE.2024-03-03T17-50-39Z"  # Example: "minio.RELEASE.2025-01-17T05-24-29Z" or "latest"
  minio_binary_arch         = "linux-amd64"
  ebs_root_volume_size      = 10
  ebs_storage_volume_size   = 100
  make_private              = false
  ec2_instance_type         = "t2.medium"
  ec2_ami_image             = "ami-0d413c682033e11fd"        # (ami-0d413c682033e11fd) Ubuntu 22.04 - us-west-1
  az_count                  = 2                              # Number of AZs to use
  subnets                   = module.minio-vpc-west-1[0].subnets
  num_disks                 = 4                              # Creates a number of disks
  sshkey                    = var.sshkey                     # Use env variables | export TF_VAR_sshkey=$(cat ~/.ssh/your-key-name.pub)
  ec2_key_name              = "sshkey"
  package_manager           = "apt"
  bastion_host              = false
}


//////////////////////
// West 2 Cluster 1 //
//////////////////////

module "minio-west-2-cluster1" {
  for_each = toset([for i in range(local.regions_data["us-west-2"]) : tostring(i+1) ])
  source = "github.com/excircle/tf-aws-minio-cluster"
  providers = {
    aws = aws.us-west-2
  }

  application_name          = format("minio-west-2-cluster%s", each.value)
  system_user               = "ubuntu"
  hosts                     = 4                              # Number of nodes with MinIO installed
  vpc_id                    = module.minio-vpc-west-2[0].vpc_id
  ebs_root_volume_size      = 10
  ebs_storage_volume_size   = 100
  make_private              = false
  ec2_instance_type         = "t2.medium"
  ec2_ami_image             = "ami-0606dd43116f5ed57"        # (ami-0606dd43116f5ed57) Ubuntu 22.04 - us-west-2
  az_count                  = 2                              # Number of AZs to use
  subnets                   = module.minio-vpc-west-2[0].subnets
  num_disks                 = 4                              # Creates a number of disks
  sshkey                    = var.sshkey                     # Use env variables | export TF_VAR_sshkey=$(cat ~/.ssh/your-key-name.pub)
  ec2_key_name              = "sshkey"
  package_manager           = "apt"
  bastion_host              = false
}

#------------------------------------------------------------------------------
# MinIO Disks
#------------------------------------------------------------------------------

////////////////////
// East 1 Disk(s) //
////////////////////

module "minio-east-1-disks" {
  count = local.regions_data["us-east-1"] > 0 ? 1 : 0
  source = "github.com/excircle/tf-aws-minio-disks"
  providers = {
    aws = aws.us-east-1
  }

  minio_hosts = module.minio-east-1-cluster1["1"].minio_host_info
  disk_names = module.minio-east-1-cluster1["1"].disk-names
  ebs_storage_volume_size = module.minio-east-1-cluster1["1"].ebs_storage_volume_size
}

////////////////////
// East 2 Disk(s) //
////////////////////

module "minio-east-2-disks" {
  count = local.regions_data["us-east-2"] > 0 ? 1 : 0
  source = "github.com/excircle/tf-aws-minio-disks"
  providers = {
    aws = aws.us-east-2
  }

  minio_hosts = module.minio-east-2-cluster1["1"].minio_host_info
  disk_names = module.minio-east-2-cluster1["1"].disk-names
  ebs_storage_volume_size = module.minio-east-2-cluster1["1"].ebs_storage_volume_size
}

////////////////////
// West 1 Disk(s) //
////////////////////

module "minio-west-1-disks" {
  count = local.regions_data["us-west-1"] > 0 ? 1 : 0
  source = "github.com/excircle/tf-aws-minio-disks"
  providers = {
    aws = aws.us-west-1
  }

  minio_hosts = module.minio-west-1-cluster1["1"].minio_host_info
  disk_names = module.minio-west-1-cluster1["1"].disk-names
  ebs_storage_volume_size = module.minio-west-1-cluster1["1"].ebs_storage_volume_size
}

////////////////////
// West 2 Disk(s) //
////////////////////

module "minio-west-2-disks" {
  count = local.regions_data["us-west-2"] > 0 ? 1 : 0
  source = "github.com/excircle/tf-aws-minio-disks"
  providers = {
    aws = aws.us-west-2
  }

  minio_hosts = module.minio-west-2-cluster1["1"].minio_host_info
  disk_names = module.minio-west-2-cluster1["1"].disk-names
  ebs_storage_volume_size = module.minio-west-2-cluster1["1"].ebs_storage_volume_size
}