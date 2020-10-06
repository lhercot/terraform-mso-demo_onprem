output "vmware_vds" {
  value = mso_schema_site_anp_epg_domain.db_domain.dn
  description = "The name of the VMware VDS used"
}

output "vmware_portgroup" {
  value = "${var.tenant}|${var.name_prefix}App|DB"
  description = "The name of the VMware portgroup used"
}

output "onprem_site_id" {
  value = data.mso_site.on_premises.id
}