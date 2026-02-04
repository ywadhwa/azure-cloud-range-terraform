# Azure Cloud Range Terraform Baseline

A realistic, low-cost enterprise-like Azure lab baseline built with Terraform. Designed to be simple, reproducible, and easy to extend for security research.

## Architecture (ASCII)

```
                       +----------------------+
                       |      rg-hub-network  |
                       |  vnet-hub 10.0.0.0/16|
                       |  snet-jumpbox 10.0.10|
                       |  snet-shared-services|
                       +----------+-----------+
                                  |
                      +-----------+-----------+
                      |                       |
        +-------------+---------+   +---------+-------------+
        |   rg-prod-app          |   |  rg-nonprod-app      |
        | vnet-prod 10.1.0.0/16  |   | vnet-nonprod 10.2.0.0/16 |
        | snet-prod-app 10.1.1.0 |   | snet-nonprod-app 10.2.1.0 |
        +------------------------+   +-------------------------+

        +------------------------+   +-------------------------+
        |  rg-shared-services    |   |  rg-identity            |
        |  Key Vault (RBAC)      |   |  Entra users/groups/app |
        +------------------------+   +-------------------------+

        +------------------------+
        |  rg-logging (optional) |
        |  Log Analytics         |
        +------------------------+
```

## Features

- Hub-and-spoke VNets with peering (hub <-> prod, hub <-> nonprod)
- Linux + Windows VMs (minimal, burstable SKUs)
- Key Vault with RBAC and managed identity access
- Entra ID users, groups, app registration, service principal
- RBAC group assignments at subscription/RG scopes
- Optional jumpbox public IP and Log Analytics

## Cost Controls & Recommendations

- Defaults use burstable VM sizes (B-series) and no public IPs on app VMs.
- Log Analytics is disabled by default (`enable_log_analytics = false`).
- Use TTL tags and destroy resources when done.
- Avoid Azure Firewall, NAT Gateway, Defender, Sentinel, or other premium services.

## Quickstart

```bash
cd infra/envs/baseline
cp terraform.tfvars.example terraform.tfvars

# Update terraform.tfvars with your tenant domain and strong passwords

terraform init
terraform fmt
terraform validate
terraform apply
```

To destroy:

```bash
terraform destroy
```

## Safety Warning

**Lab use only.** This is a research baseline intended for controlled environments. Do not deploy in production.
