locals {
  rg_name = "rg-${var.name_prefix}-${var.location}-${var.prefix}-${var.environment}"
  sa_name = "sa${var.name_prefix}${var.location}${var.prefix}${var.environment}"
}