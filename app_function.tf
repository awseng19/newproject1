resource "azurerm_service_plan" "fun1" {
  name                = "example-service-plan"
  resource_group_name = azurerm_resource_group.mcit420zz5um4.name
  location            = azurerm_resource_group.mcit420zz5um4.location
  os_type             = "Linux"
  sku_name            = "Y1"  # Consumption Plan
}
resource "azurerm_function_app" "function1" {
  name                       = "yourfirstnamemcitfunction"
  resource_group_name        = azurerm_resource_group.mcit420zz5um4.name
  location                   = azurerm_resource_group.mcit420zz5um4.location
  storage_account_name       = azurerm_storage_account.mcitstorageaccount.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id
  os_type                    = "linux"

  site_config {
    application_stack {
      python_version = "3.8"
    }
  }
}
