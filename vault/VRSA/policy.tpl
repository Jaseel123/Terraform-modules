%{ for secret_path in secret_paths ~}
path "${prefix}/data/${secret_path}" {
  capabilities = ["read"]
}
%{ endfor ~}