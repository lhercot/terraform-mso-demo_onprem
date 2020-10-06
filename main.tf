terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}

provider "mso" {
  # Configuration options
  // Requires ENV variable TF_VAR_mso_username 
  username  = var.mso_username
  // Requires ENV variable TF_VAR_mso_password
  password  = var.mso_password
  // Requires ENV variable TF_VAR_mso_url
  url       = var.mso_url

  insecure  = true
}

data "mso_site" "on_premises" {
  name  = var.site_name
}

data "mso_schema" "hybrid_cloud" {
  name          = var.schema_name
}

resource "mso_schema_site" "on_premises_shared" {
  schema_id     = data.mso_schema.hybrid_cloud.id
  site_id       = data.mso_site.on_premises.id
  template_name = "Template1"
}

resource "mso_schema_site_anp_epg_domain" "db_domain" {
  schema_id            = data.mso_schema.hybrid_cloud.id
  template_name        = "Template1"
  site_id              = data.mso_site.on_premises.id
  anp_name             = "${var.name_prefix}App"
  epg_name             = "DB"
  domain_type          = "vmmDomain"
  dn                   = "VMware-VMM"
  deploy_immediacy     = "lazy"
  resolution_immediacy = "lazy"
  depends_on           = {
    mso_schema_site.on_premises_shared
  }
}