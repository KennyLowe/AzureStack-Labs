#Template validator lab

# Download the template.
md c:\AzureStack_Labs\ValidateTemplates
Invoke-WebRequest -uri "https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Validate%20Templates/azuredeploy.json" `
-OutFile c:\AzureStack_Labs\ValidateTemplates\azuredeploy.json

# Change to the Template Validator directory and import the module
cd \AzureStack-Tools-master\TemplateValidator
Import-Module .\TemplateValidator\AzureRM.TemplateValidator.psm1

#Run the template validator against the template.  This will log to the console and also create a report file.
Test-AzureRMTemplate -TemplatePath c:\AzureStack_Labs\ValidateTemplates\azuredeploy.json `
-CapabilitiesPath AzureStackCloudCapabilities_with_AddOns_20170627.json `
-Verbose
