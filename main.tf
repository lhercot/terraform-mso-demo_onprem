terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
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
  template_name        =  mso_schema_site.on_premises_shared.template_name
  site_id              = data.mso_site.on_premises.id
  anp_name             = "${var.name_prefix}App"
  epg_name             = "DB"
  domain_type          = "vmmDomain"
  dn                   = "VMware-VMM"
  deploy_immediacy     = "immediate"
  resolution_immediacy = "pre-provision"
}