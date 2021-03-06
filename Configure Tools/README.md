# Azure Stack Labs - Configure Tools

### Objective	

- Configure common development tools for Azure and Azure Stack.

#### Task 1: Install Visual Studio Code and extension
You'll install Visual Stode Code, and the Azure Resource Manager Tools extension to work with Azure Resource Manager templates.

1. Install [Visual Studio Code](https://code.visualstudio.com/Download).  Accept the installation defaults, except enable "Register Code as an editor for supported file types".

    ![image3](./images/image3.png)

2. Once installed, select "Extensions":

    ![image1](./images/image1.png)
3. Search for "Azure Resource Manager Tools" and select "Install":

    ![image2](./images/image2.png)

4.  Once installed, restart Visual Studio Code to activate the extension.  

#### Task 2: Install PowerShell
Azure Resource Manager PowerShell is used to manage Azure Resources.  In this step, you'll install PowerShell, and download the Azure Stack tools. 

Open an administrative PowerShell ISE session, and run the following:

```PowerShell
# Set the module repository and the execution policy
Set-PSRepository `
  -Name "PSGallery" `
  -InstallationPolicy Trusted

Set-ExecutionPolicy RemoteSigned `
  -force

# Uninstall any existing Azure PowerShell modules. 
# To uninstall, close all the active PowerShell sessions and run the following command:
Get-Module -ListAvailable | `
  where-Object {$_.Name -like “Azure*”} | `
  Uninstall-Module

# Install PowerShell for Azure Stack
Install-Module `
  -Name AzureRm.BootStrapper `
  -Force

Use-AzureRmProfile `
  -Profile 2017-03-09-profile `
  -Force

Install-Module `
  -Name AzureStack `
  -RequiredVersion 1.2.10 `
  -Force 

# Download Azure Stack tools from GitHub
cd \

invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/master.zip `
  -OutFile master.zip

expand-archive master.zip `
  -DestinationPath . `
  -Force

cd AzureStack-Tools-master
```

## For more information
Be sure to check out the official documentation on [installing PowerShell for Azure Stack](https://docs.microsoft.com/en-us/azure/azure-stack/azure-stack-powershell-install).

## Summary

In this module, you configured Visual Studio Code and PowerShell for Azure and Azure Stack, which you will use in future modules.

- [x] 1. [ARM Overview](/ARM%20Overview/README.md)
- [x] 2. [Configure Tools](/Configure%20Tools/README.md)
- [ ] 3. [Custom Policy](/Custom%20Policy/README.md)
- [ ] 4. Validate Templates
