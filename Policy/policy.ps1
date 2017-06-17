# Login to Azure
Login-AzureRmAccount
$s = Select-AzureRmSubscription -SubscriptionName "[Your subscription name]"

# Create a new resource group
$resourceGroup = New-AzureRmResourceGroup -Name "AzureStack" -Location "West US"
$resourceGroupName = $resourceGroup.ResourceGroupName

# Deploy ARM Template
New-AzureRmResourceGroupDeployment -Name "Azure Only" -ResourceGroupName $rgName -TemplateUri https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Policy/azuredeploy.json -Verbose

# Download Azure Stack Tools
Invoke-WebRequest https://github.com/Azure/AzureStack-Tools/archive/master.zip -OutFile master.zip
Expand-Archive master.zip -DestinationPath \. -Force
cd \AzureStack-Tools-master

# Import policy module
import-module .\Policy\AzureStack.Policy.psm1

# Create a new policy
$policy = New-AzureRmPolicyDefinition -Name AzureStackPolicy -Policy (Get-AzureStackRmPolicy)

# Assign the new policy to the resource group
New-AzureRmPolicyAssignment -Name AzureStackPolicy -PolicyDefinition $policy -Scope $ResourceGroup.ResourceId

# Deploy the ARM Template
New-AzureRmResourceGroupDeployment -Name "Azure Only" -ResourceGroupName $rgName -TemplateUri https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Policy/azuredeploy.json -Verbose

# Deploy the ARM Template after updating
$localTemplate = "c:\temp\azuredeploy.json"
Invoke-RestMethod https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Policy/azuredeploy.json -OutFile $localTemplate
New-AzureRmResourceGroupDeployment -Name "Azure Stack and Azure" -ResourceGroupName $rgName -TemplateFile $localTemplate -Verbose