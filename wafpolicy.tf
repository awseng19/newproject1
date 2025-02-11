

# Create WAF Policy
resource "azurerm_web_application_firewall_policy" "mcit420zz5um3" {
  name                = "pp-waf-policy"
  resource_group_name = azurerm_resource_group.mcit420zz5um3.name
  location            = azurerm_resource_group.mcit420zz5um3.location
 
  custom_rules {
    name      = "BlockSQLInjection"
    priority  = 1
    rule_type = "MatchRule"
 
    match_conditions {
      match_variables {
        variable = "RequestHeader"
        selector = "User-Agent"
      }
      operator = "Contains"
      values    = ["SQLmap"]
    }
 
    action = "Block"
  }
 
  # Default action for WAF policy
  default_action {
    action_type = "Block"
  }
 
  # Rules to handle
  managed_rules {
    managed_rule_set {
      rule_set_type = "OWASP"
      rule_set_version = "3.2"
    }
  }
 
  # Optionally enable logging for WAF policy
  logging {
    enabled               = true
    retention_policy_days = 30
    destination {
      storage_account_id = "/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}"
    }
  }
 
  # Optional: Enable diagnostics settings for monitoring WAF logs
  diagnostic_settings {
    name                         = "example-diagnostic-settings"
    storage_account_id           = "/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}"
    eventhub_name                = "example-eventhub"
    log_analytics_workspace_id   = "/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.OperationalInsights/workspaces/{workspace-name}"
  }
}
 
# Optional: If you want to associate this WAF policy with an Application Gateway
resource "azurerm_application_gateway" "example" {
  name                = "example-app-gateway"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }
 
  frontend_ip_configuration {
    name                 = "example-frontend-ip"
    public_ip_address_id = "/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/publicIPAddresses/{public-ip-name}"
  }
 
  # WAF policy association with Application Gateway
  web_application_firewall_configuration {
    enabled              = true
    firewall_policy_id   = azurerm_web_application_firewall_policy.example.id
    default_redirect_url = "https://www.example.com"
    rule_set_type        = "OWASP"
    rule_set_version     = "3.2"
  }
}
 
# Output the WAF Policy ID
output "waf_policy_id" {
  value = azurerm_web_application_firewall_policy.example.id
}
