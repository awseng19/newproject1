

resource "azurerm_web_application_firewall_policy" "fire1" {
  name                = "maryam"
  resource_group_name = azurerm_resource_group.mcit420zz5um.name
  location            = azurerm_resource_group.mcit420zz5um.location

  policy_settings {
    mode = "Prevention"
    request_body_check = true
  }
  custom_rules {
    name      = "BlockSQLInjection"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "QueryString"
      }
      operator           = "Contains"
      negation_condition = false
      match_values       = ["SELECT", "DROP", "INSERT"]
    }

    action = "Block"
  }
}
