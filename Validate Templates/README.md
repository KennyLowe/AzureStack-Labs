# Azure Stack Labs - Validate Templates

## Validate templates
In these steps, you validate a template by using the AzureRM.TemplateValidator PowerShell module.  This tool will identify common template inconsistencies that must be addressed for template portability between Azure and Azure Stack. You will use the same template that previously failed, and will see the same changes highlighted.   

1. Download the Azure Resource Manager template with this PowerShell:

```PowerShell
    md c:\AzureStack_Labs\ValidateTemplates
    Invoke-WebRequest -uri https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Policy/azuredeploy.json `
    -OutFile c:\AzureStack_Labs\ValidateTemplates\azuredeploy.json
```

2.  Import the AzureRM.TemplateValidator.psm1 PowerShell module:
    
    ```PowerShell
    cd \AzureStack-Tools-master\TemplateValidator
    import-module .\TemplateValidator\AzureRM.TemplateValidator.psm1
    ```

3.  Run the template validator:

    ```PowerShell
    test-azureRMTemplate -TemplatePath c:\AzureStack_Labs\ValidateTemplates\azuredeploy.json`
    -CapabilitiesPath AzureStackCloudCapabilities_with_AddOns_20170627.json `
    -Verbose
    ```

4.  Open the HTML report from c:\AzureStack_Labs.

5.  Notice the warnings issued.  You will see the APIVersion and Storage Type is not supported.

- [x] 1. [ARM Overview](/ARM%20Overview/README.md)
- [x] 2. [Configure Tools](/Configure%20Tools/README.md)
- [x] 3. [Custom Policy](/Custom%20Policy/README.md)
- [x] 4. [Validate Templates](/Validate%20Templates/README.md)
