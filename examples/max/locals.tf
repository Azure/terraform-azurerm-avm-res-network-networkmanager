locals {
  azure_regions = [
    "westeurope",
    "northeurope",
    "eastus",
    "eastus2",
    "westus",
    "westus2",
    "southcentralus",
    "northcentralus",
    "centralus",
    "eastasia",
    "southeastasia",
  ]
  ip_space = {
    hub = "10.0.0.0/24"
    spokes = [
      "10.0.1.0/24",
      "10.0.2.0/24",
      "10.0.3.0/24",
    ]
  }
}
