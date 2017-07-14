### Task 1: Create an Azure resource group and deploy and ARM template ###

# Login to Azure
Login-AzureRmAccount

# Get Azure Subscriptions
Get-AzureRmSubscription

# Select your subscription
$s = Select-AzureRmSubscription -SubscriptionName "[Your subscription name]"

# Create a new resource group
$resourceGroup = New-AzureRmResourceGroup -Name "AzureStack" -Location "West US"
$resourceGroupName = $resourceGroup.ResourceGroupName

# Deploy ARM Template
Try {
New-AzureRmResourceGroupDeployment -Name "NoPolicy" `
    -ResourceGroupName $resourceGroupName `
        -TemplateUri "https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Custom%20Policy/azuredeploy.json" `
    -Verbose -ErrorAction Stop
}
Catch {
Write-Host $_.Exception.Message -ForegroundColor Red
}

### Task 2: Use the Azure Stack Policy module to constrain the resource group ###

# Download Azure Stack Tools
Invoke-WebRequest https://github.com/Azure/AzureStack-Tools/archive/master.zip -OutFile master.zip
Expand-Archive master.zip -DestinationPath \. -Force
cd \AzureStack-Tools-master

# Import policy module
import-module .\Policy\AzureStack.Policy.psm1

# Create a new policy
$policy = New-AzureRmPolicyDefinition -Name AzureStackPolicy -Policy (Get-AzSPolicy)

# Assign the new policy to the resource group
New-AzureRmPolicyAssignment -Name AzureStackPolicy -PolicyDefinition $policy -Scope $ResourceGroup.ResourceId

### Task 3: Test the limits of the constrained resource group ###

# Deploy the ARM Template
Try {
New-AzureRmResourceGroupDeployment -Name "Policy" `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
        -TemplateUri "https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Custom%20Policy/azuredeploy.json" `
    -Verbose -ErrorAction Stop
}
Catch {
Write-Host $_.Exception.Message -ForegroundColor Red
}

### Task 4: Update the template for Azure Stack ###

# Download a local copy of the ARM Template for updating
$localTemplate = "c:\AzureStack_Labs\CustomPolicy\azuredeploy.json"
Invoke-RestMethod "https://raw.githubusercontent.com/Azure/AzureStack-Labs/master/Custom%20Policy/azuredeploy.json" -OutFile $localTemplate

# Deploy the ARM Template after updating
Try {
New-AzureRmResourceGroupDeployment -Name "Fixed" `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -TemplateFile $localTemplate `
    -Verbose -ErrorAction Stop
}
Catch {
Write-Host $_.Exception.Message -ForegroundColor Red
}