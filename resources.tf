# App Service Plan
module "app_service_plan" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/app-service-plan.git?ref=AZ-68-default-scaling"

  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  location_short      = "${var.location_short}"
  name_prefix         = "${coalesce(var.app_service_plan_name_prefix, var.name_prefix)}"

  sku = "${var.app_service_plan_sku}"

  kind = "${lookup(var.app_service_plan_sku, "tier") == "Dynamic" ? "FunctionApp" : var.app_service_plan_os}"

  extra_tags = "${merge(var.extra_tags, var.app_service_plan_extra_tags, local.default_tags)}"
}

module "function_app" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/function-app-single.git?ref=TER-372-azure-function-linux"

  client_name         = "${var.client_name}"
  environment         = "${var.environment}"
  stack               = "${var.stack}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  location_short      = "${var.location_short}"

  name_prefix                      = "${var.name_prefix}"
  storage_account_name_prefix      = "${var.storage_account_name_prefix}"
  application_insights_name_prefix = "${var.application_insights_name_prefix}"
  function_app_name_prefix         = "${var.function_app_name_prefix}"

  app_service_plan_id               = "${module.app_service_plan.app_service_plan_id}"
  function_language                 = "${var.function_language}"
  function_app_application_settings = "${var.function_app_application_settings}"

  create_application_insights_resource     = "${var.create_application_insights_resource}"
  application_insights_instrumentation_key = "${var.application_insights_instrumentation_key}"
  application_insights_type                = "${var.application_insights_type}"

  create_storage_account_resource   = "${var.create_storage_account_resource}"
  storage_account_connection_string = "${var.storage_account_connection_string}"

  extra_tags                      = "${merge(var.extra_tags, local.default_tags)}"
  application_insights_extra_tags = "${merge(var.extra_tags, var.application_insights_extra_tags, local.default_tags)}"
  storage_account_extra_tags      = "${merge(var.extra_tags, var.storage_account_extra_tags, local.default_tags)}"
  function_app_extra_tags         = "${merge(var.extra_tags, var.function_app_extra_tags, local.default_tags)}"
}
