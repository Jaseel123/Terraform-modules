%{ for path in vault_paths ~}
path "${path}" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
%{ endfor ~}
%{ for item in vault_additional_permissions ~}
path "${item.path}" { 
  capabilities = ${item.permissions}
}
%{ endfor ~}
