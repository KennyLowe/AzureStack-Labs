# Azure Stack Labs - Validate Templates

## Validate templates
In these steps, you validate the previous template by using the AzureRM.TemplateValidator PowerShell module.  This tool will identify common template inconsistencies that must be addressed for template portability between Azure and Azure Stack.  

1. Download the Azure Resource Manager template with this PowerShell:

```PowerShell
    Invoke-WebRequest -uri https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Policy/azuredeploy.json `
    -OutFile c:\AzureStack_Labs\azuredeploy01.json
```

2.  Import the AzureRM.TemplateValidator.psm1 PowerShell module:
    
    ```PowerShell
    cd \AzureStack-Tools-master\TemplateValidator
    import-module .\TemplateValidator\AzureRM.TemplateValidator.psm1
    ```

3.  Run the template validator:

    ```PowerShell
    test-azureRMTemplate -TemplatePath c:\AzureStack_Labs\azuredeploy01.json`
    -CapabilitiesPath AzureStackCloudCapabilities_with_AddOns_20170627.json `
    -Verbose
    ```

4.  Open the HTML report from c:\AzureStack_Labs.

5.   
