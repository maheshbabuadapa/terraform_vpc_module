variable "vpc_name" {
    type = string
}

variable "app_region" {
	type = string
}

variable "vpc_cidir" { 
	default = {}
}

variable "public_subnets_cidr" {
	type = list
	default = []
}

variable "private_subnets_cidr" {
	type = list
	default = []	
}

variable "private_azs" {
	type = list
	default = []	
}

variable "public_azs" {
	type = list
	default = []	
}