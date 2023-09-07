terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.71.0"
    }
  }
}

resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = "East US"
}

resource "azurerm_storage_account" "appstorage0309" {
  name                     = "appstorage0309"
  resource_group_name      = "app-grp"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [ azurerm_resource_group.appgrp ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "appstorage0309"
  container_access_type = "blob"
  depends_on = [azurerm_storage_account.appstorage0309 ]
}

resource "azurerm_storage_blob" "maintf" {
  name                   = "main.tf"
  storage_account_name   = "appstorage0309"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "main.tf"
  depends_on = [ azurerm_storage_container.data ]
}