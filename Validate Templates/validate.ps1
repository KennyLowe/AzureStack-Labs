#Template validator lab

# Step 1:  Download the template.
Invoke-WebRequest -uri "https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Validate%20Templates/azuredeploy.json" `
-OutFile c:\AzureStack_Labs\ValidateTemplates\azuredeploy.json

# Step 2:  Change to the Template Validator directory and import the module
cd \AzureStack-Tools-master\TemplateValidator
Import-Module .\AzureRM.TemplateValidator.psm1

# Step 3:  Run the template validator against the template.  This will log to the console and also create a report file.
Test-AzureRMTemplate -TemplatePath c:\AzureStack_Labs\ValidateTemplates\azuredeploy.json `
    -CapabilitiesPath AzureStackCloudCapabilities_with_AddOns_20170627.json `
    -IncludeStorageCapabilities `
    -Verbose

# Step 4:  Open the HTML report here:  C:\AzureStack-Tools-master\TemplateValidator\TemplateValidationReport.html

