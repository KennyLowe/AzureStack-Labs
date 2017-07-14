# Azure Stack Labs - ARM Overview

At the core of Microsoft cloud platform, Azure Resource Manager provides a RESTful API that allows the wide variety of user interfaces to communicate with the platform. The capabilities in Azure Resource Manager ensure that the tenant experience is consistent regardless what tool is used. Azure Resource Manager applies a set of policies and features at its core, ensuring all user interfaces can leverage the same capabilities and are restricted by the same policies. 

### Infrastructure as Code

Infrastructure as Code allows you to define the desired state of your application in a template. The template is then used to deploy the application. The template provides the ability to repeat a deployment exactly but it can also ensure that a deployed application stays consistent with the desired state defined in the template over time. If you want to make a change to the application, you would make that change in the template. The template can then be used to apply the desired state to the existing application instance over its complete lifecycle. Templates can be parameterized; creating a reusable artifact that is used to deploy the same application to different environments, accepting the relevant parameters for each environment. 

### Template authoring

An application consists of different building blocks. A virtual machine is not a single resource but contains different individual resources like a virtual hard disk and a virtual network interface card. These resources can depend on other resources or can have other resources depending on it. This decomposed model allows an application to be constructed completely to your needs. Before you start creating your template it is a good idea to create a graphical design of your application first. You can think of the graphical design like an index of a book. The graphical design helps you to understand the required resources and the dependencies of between these resources. 

### Language
Azure Resource Manager accepts JavaScript Object Notation (JSON) templates that comply with a JSON schema. JSON is an industry standard, human readable language. 

You can follow along in this Lab as we build a simple template. Create a new template file called azuredeploy.json. Copy and paste the following code, that contains all the top level elements, in to the file.

``` JSON
{
	"$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
	"contentVersion": "1.0.0.0",
	"parameters": {},
	"variables": {},
	"resources": [],
	"outputs": {}
}
```

An Azure Resource Manager template uses 6 top level elements. Each element has a distinct role in the template.
ELEMENT	| REQUIRED | DESCRIPTION
--- | --- | ---
$schema | ✓ |Location of the JSON schema file that describes the version of the template language. You should use the standard URL: https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#
contentVersion | ✓ | Version of the template (such as 1.0.0.0). You can provide any value for this element. When deploying resources using the template, this value can be used to make sure that the right template is being used.
parameters| --- | Values that are provided when deployment is executed to customize resource deployment.
variables | --- | Values that are used as JSON fragments in the template to simplify template language expressions.
resources | ✓ | Resource types that are deployed or updated in a resource group.
outputs | --- | Values that are returned after deployment.

Conventionally, the first single word in an attribute name is specified in lowercase while additional words are appended to the first word without spaces and start with an Uppercase (e.g. contentVersion). This convention is commonly referred to as “Camel case”.
Adding resources to your template
For the example we will use in this whitepaper, a storage account is the first resource that will be added to the template. The code blocks in this whitepaper will only contains the changes to our code and not the complete template. This will help to emphasize the differences in each step.
"resources": [
	{
		"name": "myStorageAccount",
		"type": "Microsoft.Storage/storageAccounts",
		"apiVersion": "2015-06-15",
		"location": "East US",
		"properties": {
			"accountType": "Standard_LRS"
		}
	}
],
Within the resources array we added a new object with an open and closing curly bracket. Within that object the common attributes (name, type, apiVersion, location and properties) are specified. The value of the properties attribute is enclosed in curly brackets, indicating that the value allows for multiple different child attributes. This template deploys a storage account configured with the type set to the Local Redundant Storage option in the East US region. 
All resource types require some common attributes like "name" and "type". Azure Resource Manager uses these attributes to ensure that the correct resource provider is handling the request. The following common attributes are required across all resources.
•	name is used to name the deployed resource. Each resource of the same resource type within a single resource group must be uniquely named. Depending on the resource type it may also require uniqueness at either subscription, tenant or global scopes.
•	type contains the resource provider and the resource type within that resource provider.
•	apiVersion is used to identify the API version for the resource type. Multiple API versions can exist for a single resource type. These API versions are used to identify the available properties of a resource type.
•	location sets the region for the resource to be deployed into. This can be a region in Microsoft Azure or a region in Microsoft Azure Stack, hosted by a service provider or running in your datacenter

Besides these required common attributes, each different resource can have optional common attributes like tags or comments and will have properties that are resource specific. For example, a storage account requires a replication policy while a virtual network requires a subnet. Resource specific properties are configured in the properties attribute.
•	properties contain resource specific information

Adding parameters to your template
Consistency of Azure Resource Manager across clouds allows the template to be used for different environments. A scaled down version of your application can be sufficient for a test environment, while a production environment requires a more robust version. Depending on the desired end state, specific options might require other settings. For the example in this whitepaper, you may want to use a different replication mechanism for the storage account when the template is deployed to a different environment. This can be achieved by specifying parameters. The values for these parameters are requested from the tenant when a template is deployed. The values for the parameters can be passed to the template deployment in different ways. 
"parameters": {
	"storageAccountType": {
		"type": "string",
		"defaultValue": "Standard_LRS",
		"allowedValues": [
		"Standard_LRS",
		"Standard_GRS",
		"Standard_RAGRS"
		]
	}
},
A parameter requires a type, but can optionally contain a default value and allowed values. The type attribute specifies the expected type of input (string, int, bool, array, object, secureString). The type can also be used to render a user interface field when deploying the template from the tenant portal. The default value is used if no value is specified by the tenant at deployment time. If a parameter does not contain a default value, the tenant is required to submit a value when deploying the template.
While the parameter has been specified, the parameter is not used in the resource yet. The hard-coded value of the storage account type needs to be replaced with the parameter. The value must refer to the correct parameter in the format parameters('parameterName') enclosed by two square brackets. The square brackets allow Azure Resource Manager to identify the content as a function to be evaluated instead of a static string.
"resources": [
	{
		"name": "storageAccount",
		"type": "Microsoft.Storage/storageAccounts",
		"apiVersion": "2015-06-15",
		"location": "East US",
		"properties": { 
			"accountType": "[parameters('storageAccountType')]" 
		}
	}
],
By adding a parameter to your template and replacing the fixed value in a resource with that parameter, the template is now more dynamic. While the concept of replacing fixed values by parameters is applicable throughout the template, just be aware of the effect that a larger number of parameters can have on the deployment experience. If a tenant is asked to submit many values for deploy a template, the experience will not be very user friendly. The deployment experience can be improved by specifying a default value where possible and minimize the number of parameters overall. Combining parameters with variables can also improve the experience while retaining the dynamic nature of a template.
Adding variables to your template
Where parameters are used to request a value from the tenant at deployment time, a variable is a value that can be reused throughout the template without requiring user input. For example, a storage account resource can be used by a virtual machine resource to store its virtual disks. The virtual machine resource will need to reference the storage account resource name in its configuration.
You could specify the name for the storage account as a static value for both the storage account resource and the virtual machine resource. This is problematic as the name can be potentially changed in one location and not the other. Instead, it is much easier to create a single variable that is referenced by all the relevant resources.
"variables": {
	"storageAccountName": "myStorageAccountName"
},
The variable can be referenced using the function: variables('variableName'). The function, just like the parameter function, is enclosed by two square brackets indicating that it should be evaluated by Azure Resource Manager accordingly.
"resources": [
	{
		"name": "[variables('storageAccountName')]",
		"type": "Microsoft.Storage/storageAccounts",
		"apiVersion": "2015-06-15",
		"location": "East US",
		"properties": { 
			"accountType": "[parameters('storageAccountType')]" 
		}
	}
],
Template functions
Azure Resource Manager provides template functions that make the template orchestration engine very powerful. Template functions enable operations on values within the template at deployment time. A simple example of a template function is to concatenate two strings into a single string. You could use a function that concatenate strings and pass in the two strings as parameters to the functions.
Template functions can be used in variables, resources and outputs in Azure Resource Manager templates. Template functions can reference parameters, other variables or even objects related to the deployment. For example, a template function can reference the ID of the resource group.
  https://azure.microsoft.com/en-us/documentation/articles/resource-group-template-functions/
Common examples of template function usage
The example we used in this whitepaper currently contains a variable for the storage account name. This variable is set to the value "myStorageAccountName". Besides other requirements, a storage account requires a globally unique fully-qualified domain name (FQDN). After you create the storage account, this domain is used to allow you to access your storage resources using a URL. In our example, the chance that the name myStorageAccountName is not used yet is very small. If we try to deploy a storage account with that name, the deployment will likely fail. The best practice for a storage account name is to use a variable that generates a unique name. To accomplish this, we can concatenate a unique string to the text ‘storage’. This can be achieved by using the concat(), resourceGroup() and uniqueString() template functions. 
The storage account name is generated by concatenating a unique string that is derived from the id of the resource group that the template is being deployed to and the string 'storage'. Because the storage account resource already references the variable for the storageAccountName, the resource itself does not require a change to reflect the new value of the variable. 
"variables": {
	"storageAccountName": "[concat(uniquestring(resourceGroup().id),'storage')]"
},
Although we have created a parameter for the storageAccountType, each time the template is deployed the storage account will always be created in "East US". That fixed value is specified in the location attribute of the resource. The obvious solution would be to define parameter for the location and ask the user for the region. To make this less error prone a list of allowed values would ensure a valid selection, but it also limits the regions you can deploy the resource to. As new regions are added to the platform, it can be challenging when deploying to Microsoft Azure and even more challenging for Microsoft Azure Stack, where you might specify your own regions. A template function solves this challenge. You can configure each resource to deploy to the same location as the target resource group using the template function resourceGroup().location, the template remains reusable across clouds and requires one less input from the tenant. Using this function each resources location ensures that all resources will be deployed in the same region as the resource group.
"resources": [
	{
		"name": "[variables('storageAccountName')]",
		"type": "Microsoft.Storage/storageAccounts",
		"apiVersion": "2015-06-15",
		"location": "[resourceGroup().location]",
		"properties": { "accountType": "[parameters('storageAccountType')]" }
	}
],
Some applications can require a distributed setup across regions. In these cases, create a single variable for the deviating location and reference that variable for the resources that require placement in region other than the resource group.
Adding outputs to your template
A template can also contain outputs. The outputs and their values are displayed and recorded when the deployment is finished. Outputs can be useful to display properties of a deployed resource (e.g. the FQDN of a web server). Each output requires a type (string, int, bool, array, object, secureString) and can contain template functions, parameters and variables.
"outputs": {
	"storageAccountEndpoint": {
		"type": "string",
		"value": "[variables('storageAccountName')]"
	}
}
You might be accustomed to the option to get the content of a variable. It is possible to create a template without any resources, but with outputs to validate the content of more complex template functions in the template. This template will deploy very fast, since there are no resources deployed, but still allow you to verify the output of the template function.


## Summary

Congratulations on completing this Quick Start Challenge! In this lab you’ve learned what an ARM Template is and what elements are used in an ARM Template. Please proceed to the next Lab.

- [x] 1. [ARM Overview](/ARM%20Overview/README.md)
- [ ] 2. [Configure Tools](/Configure%20Tools/README.md)
- [ ] 3. Custom Policy
- [ ] 4. Validate Templates
