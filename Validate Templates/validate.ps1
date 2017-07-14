md c:\AzureStack_Labs\ValidateTemplates
Invoke-WebRequest -uri "https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Validate%20Templates/azuredeploy.json" `
-OutFile c:\AzureStack_Labs\ValidateTemplates\azuredeploy.json


cd \AzureStack-Tools-master\TemplateValidator
Import-Module .\TemplateValidator\AzureRM.TemplateValidator.psm1


Test-AzureRMTemplate -TemplatePath c:\AzureStack_Labs\ValidateTemplates\azuredeploy.json `
-CapabilitiesPath AzureStackCloudCapabilities_with_AddOns_20170627.json `
-Verbose
