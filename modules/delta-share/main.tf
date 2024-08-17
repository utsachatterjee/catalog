locals {
  multisharesmap = flatten([
    for id, val in var.shares : [
      for k, objs in val.objects :
        {
          index = objs.catalog
          objects = objs.object_names
          object_type = objs.object_type
          owner = val.owner
          comment = val.comment
          recipients = val.recipient
        }
  ]])
}

#================================================
# Retrieve all schema from catalog
#================================================
data databricks_schemas "all" {
  for_each = {for k in local.multisharesmap : k.index => k if contains(k.objects,"all")}
  catalog_name = each.value.index
}

#================================================
# Create share
#================================================
resource databricks_share "dbk2dbk" {
  for_each = {for k in local.multisharesmap : k.index => k}
  owner = each.value.owner
  name = "share-${each.value.index}-${var.env}"
  dynamic "object" {
    for_each = contains(each.value.objects,"all") ? setsubtract(data.databricks_schemas.all[each.value.index].ids , ["${each.value.index}.default", "${each.value.index}.information_schema"]) : toset([])
    content {
      name = object.value
      data_object_type = each.value.object_type
      comment = each.value.comment
    }
  }
  dynamic "object" {
    for_each = contains(each.value.objects,"all") ? toset([]) : each.value.objects 
    content {
      name = "${each.value.index}.${object.value}"
      data_object_type = each.value.object_type
      comment = each.value.comment
    }
  }
}
#====================================================
# Grant recipient access to share [multishare block]
#====================================================
resource "databricks_grants" "sharesTOrecipients" {
  for_each = {for k in local.multisharesmap : k.index => k}
  share = databricks_share.dbk2dbk[each.key].name
  dynamic grant {
    for_each = each.value.recipients
    content {
      principal  = grant.value
      privileges = ["SELECT"]
    }
  }
  depends_on = [ databricks_share.dbk2dbk ]
}



#================================================
# Grant privilage on group on catalogs
#================================================
