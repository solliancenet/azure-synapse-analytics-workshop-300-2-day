$InformationPreference = "Continue"

$IsCloudLabs = Test-Path C:\LabFiles\AzureCreds.ps1;

if($IsCloudLabs){
        if(Get-Module -Name solliance-synapse-automation){
                Remove-Module solliance-synapse-automation
        }
        Import-Module "..\solliance-synapse-automation"

        . C:\LabFiles\AzureCreds.ps1

        $userName = $AzureUserName                # READ FROM FILE
        $password = $AzurePassword                # READ FROM FILE
        $clientId = $TokenGeneratorClientId       # READ FROM FILE
        #$global:sqlPassword = $AzureSQLPassword          # READ FROM FILE

        $securePassword = $password | ConvertTo-SecureString -AsPlainText -Force
        $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $userName, $SecurePassword
        
        Connect-AzAccount -Credential $cred | Out-Null

        $resourceGroupName = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like "*-L300*" }).ResourceGroupName

        if ($resourceGroupName.Count -gt 1)
        {
                $resourceGroupName = $resourceGroupName[0];
        }

        $ropcBodyCore = "client_id=$($clientId)&username=$($userName)&password=$($password)&grant_type=password"
        $global:ropcBodySynapse = "$($ropcBodyCore)&scope=https://dev.azuresynapse.net/.default"
        $global:ropcBodyManagement = "$($ropcBodyCore)&scope=https://management.azure.com/.default"
        $global:ropcBodySynapseSQL = "$($ropcBodyCore)&scope=https://sql.azuresynapse.net/.default"
        $global:ropcBodyPowerBI = "$($ropcBodyCore)&scope=https://analysis.windows.net/powerbi/api/.default"

        $artifactsPath = "..\..\"
        $reportsPath = "..\reports"
        $templatesPath = "..\templates"
        $datasetsPath = "..\datasets"
        $dataflowsPath = "..\dataflows"
        $pipelinesPath = "..\pipelines"
        $sqlScriptsPath = "..\sql"
} else {
        if(Get-Module -Name solliance-synapse-automation){
                Remove-Module solliance-synapse-automation
        }
        Import-Module "..\solliance-synapse-automation"

        #Different approach to run automation in Cloud Shell
        $subs = Get-AzSubscription | Select-Object -ExpandProperty Name
        if($subs.GetType().IsArray -and $subs.length -gt 1){
                $subOptions = [System.Collections.ArrayList]::new()
                for($subIdx=0; $subIdx -lt $subs.length; $subIdx++){
                        $opt = New-Object System.Management.Automation.Host.ChoiceDescription "$($subs[$subIdx])", "Selects the $($subs[$subIdx]) subscription."   
                        $subOptions.Add($opt)
                }
                $selectedSubIdx = $host.ui.PromptForChoice('Enter the desired Azure Subscription for this lab','Copy and paste the name of the subscription to make your choice.', $subOptions.ToArray(),0)
                $selectedSubName = $subs[$selectedSubIdx]
                Write-Information "Selecting the $selectedSubName subscription"
                Select-AzSubscription -SubscriptionName $selectedSubName
        }

        $resourceGroupName = Read-Host "Enter the resource group name";
        
        $userName = ((az ad signed-in-user show) | ConvertFrom-JSON).UserPrincipalName
        
        #$global:sqlPassword = Read-Host -Prompt "Enter the SQL Administrator password you used in the deployment" -AsSecureString
        #$global:sqlPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringUni([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($sqlPassword))

        $artifactsPath = "..\..\"
        $reportsPath = "..\reports"
        $templatesPath = "..\templates"
        $datasetsPath = "..\datasets"
        $dataflowsPath = "..\dataflows"
        $pipelinesPath = "..\pipelines"
        $sqlScriptsPath = "..\sql"
}

Write-Information "Using $resourceGroupName";

$uniqueId = (Get-AzResourceGroup -Name $resourceGroupName).Tags["DeploymentId"]
$subscriptionId = (Get-AzContext).Subscription.Id
$tenantId = (Get-AzContext).Tenant.Id
$global:logindomain = (Get-AzContext).Tenant.Id;

$workspaceName = "asaworkspace$($uniqueId)"
$dataLakeAccountName = "asadatalake$($uniqueId)"
$blobStorageAccountName = "asastore$($uniqueId)"
$keyVaultName = "asakeyvault$($uniqueId)"
$keyVaultSQLUserSecretName = "SQL-USER-ASA"
$sqlPoolName = "SQLPool01"
$integrationRuntimeName = "AzureIntegrationRuntime01"
$sparkPoolName = "SparkPool01"
$global:sqlEndpoint = "$($workspaceName).sql.azuresynapse.net"
$global:sqlUser = "asa.sql.admin"

$global:synapseToken = ""
$global:synapseSQLToken = ""
$global:managementToken = ""
$global:powerbiToken = "";

$global:tokenTimes = [ordered]@{
        Synapse = (Get-Date -Year 1)
        SynapseSQL = (Get-Date -Year 1)
        Management = (Get-Date -Year 1)
        PowerBI = (Get-Date -Year 1)
}

Write-Information "Assign Ownership to L300 Proctors on Synapse Workspace"
Set-SynapseRole -WorkspaceName $workspaceName -RoleId "6e4bf58a-b8e1-4cc3-bbf9-d73143322b78" -PrincipalId "37548b2e-e5ab-4d2b-b0da-4d812f56c30e"  # Workspace Admin
Set-SynapseRole -WorkspaceName $workspaceName -RoleId "7af0c69a-a548-47d6-aea3-d00e69bd83aa" -PrincipalId "37548b2e-e5ab-4d2b-b0da-4d812f56c30e"  # SQL Admin
Set-SynapseRole -WorkspaceName $workspaceName -RoleId "c3a6d2f1-a26f-4810-9b0f-591308d5cbf1" -PrincipalId "37548b2e-e5ab-4d2b-b0da-4d812f56c30e"  # Apache Spark Admin

#add the current user...
Write-Information "Assign Ownership to $($userName) on Synapse Workspace"
$user = Get-AzADUser -UserPrincipalName $userName
Set-SynapseRole -WorkspaceName $workspaceName -RoleId "6e4bf58a-b8e1-4cc3-bbf9-d73143322b78" -PrincipalId $user.id  # Workspace Admin
Set-SynapseRole -WorkspaceName $workspaceName -RoleId "7af0c69a-a548-47d6-aea3-d00e69bd83aa" -PrincipalId $user.id  # SQL Admin
Set-SynapseRole -WorkspaceName $workspaceName -RoleId "c3a6d2f1-a26f-4810-9b0f-591308d5cbf1" -PrincipalId $user.id  # Apache Spark Admin

#Set the Azure AD Admin - otherwise it will bail later
Set-SqlAdministrator -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -TenantId $tenantId -UserName $username -Sid $user.id

#add the permission to the datalake to workspace
$id = (Get-AzADServicePrincipal -DisplayName $workspacename).id
New-AzRoleAssignment -Objectid $id -RoleDefinitionName "Storage Blob Data Owner" -Scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$dataLakeAccountName" -ErrorAction SilentlyContinue;
New-AzRoleAssignment -SignInName $username -RoleDefinitionName "Storage Blob Data Owner" -Scope "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$dataLakeAccountName" -ErrorAction SilentlyContinue;

Write-Information "Setting Key Vault Access Policy"
Set-AzKeyVaultAccessPolicy -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -UserPrincipalName $userName -PermissionsToSecrets set,delete,get,list
Set-AzKeyVaultAccessPolicy -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -ObjectId $id -PermissionsToSecrets set,delete,get,list

#remove need to ask for the password in script.
$sqlPasswordSecret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name "SqlPassword"
#$global:sqlPassword = $(Get-AzKeyVaultSecret -VaultName $keyVaultName -Name "SqlPassword").SecretValueText
$global:sqlPassword = ConvertFrom-SecureString -SecureString $sqlPasswordSecret.SecretValue -AsPlainText #| ConvertFrom-SecureString -AsPlainText

Write-Information "Create SQL-USER-ASA Key Vault Secret in Key Vault $($keyVaultName)"
$secretValue = ConvertTo-SecureString $sqlPassword -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $keyVaultSQLUserSecretName -SecretValue $secretValue

Write-Information "Create KeyVault linked service $($keyVaultName)"

$result = Create-KeyVaultLinkedService -TemplatesPath $templatesPath -WorkspaceName $workspaceName -Name $keyVaultName
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

Write-Information "Create Integration Runtime $($integrationRuntimeName)"

$result = New-IntegrationRuntime -TemplatesPath $templatesPath -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -Name $integrationRuntimeName -CoreCount 16 -TimeToLive 60
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

Write-Information "Create Data Lake linked service $($dataLakeAccountName)"

$dataLakeAccountKey = Get-StorageAccountKeys -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -Name $dataLakeAccountName
$result = New-DataLakeLinkedService -TemplatesPath $templatesPath -WorkspaceName $workspaceName -Name $dataLakeAccountName  -Key $dataLakeAccountKey
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

Write-Information "Create Blob Storage linked service $($blobStorageAccountName)"

$blobStorageAccountKey = Get-StorageAccountKeys -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -Name $blobStorageAccountName
$result = New-BlobStorageLinkedService -TemplatesPath $templatesPath -WorkspaceName $workspaceName -Name $blobStorageAccountName  -Key $blobStorageAccountKey
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

Write-Information "Copy Public Data"

Confirm-ValidTokens

if ([System.Environment]::OSVersion.Platform -eq "Unix")
{
        $azCopyLink = Confirm-HttpRedirect "https://aka.ms/downloadazcopy-v10-linux"

        if (!$azCopyLink)
        {
                $azCopyLink = "https://azcopyvnext.azureedge.net/release20200709/azcopy_linux_amd64_10.5.0.tar.gz"
        }

        Invoke-WebRequest $azCopyLink -OutFile "azCopy.tar.gz"
        tar -xf "azCopy.tar.gz"
        $azCopyCommand = (Get-ChildItem -Path ".\" -Recurse azcopy).Directory.FullName
        cd $azCopyCommand
        chmod +x azcopy
        cd ..
        $azCopyCommand += "\azcopy"
}
else
{
        $azCopyLink = Confirm-HttpRedirect "https://aka.ms/downloadazcopy-v10-windows"

        if (!$azCopyLink)
        {
                $azCopyLink = "https://azcopyvnext.azureedge.net/release20200501/azcopy_windows_amd64_10.4.3.zip"
        }

        Invoke-WebRequest $azCopyLink -OutFile "azCopy.zip"
        Expand-Archive "azCopy.zip" -DestinationPath ".\" -Force
        $azCopyCommand = (Get-ChildItem -Path ".\" -Recurse azcopy.exe).Directory.FullName
        $azCopyCommand += "\azcopy"
}

#$jobs = $(azcopy jobs list)

$download = $true;

$publicDataUrl = "https://solliancepublicdata.blob.core.windows.net/"
$dataLakeStorageUrl = "https://"+ $dataLakeAccountName + ".dfs.core.windows.net/"
$dataLakeStorageBlobUrl = "https://"+ $dataLakeAccountName + ".blob.core.windows.net/"
$dataLakeStorageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $dataLakeAccountName)[0].Value
$dataLakeContext = New-AzStorageContext -StorageAccountName $dataLakeAccountName -StorageAccountKey $dataLakeStorageAccountKey
$destinationSasKey = New-AzStorageContainerSASToken -Container "wwi-02" -Context $dataLakeContext -Permission rwdl

if ($download)
{
        Write-Information "Copying single files from the public data account..."
        $singleFiles = @{
                products = "wwi-02/data-generators/generator-product/generator-product.csv"
                dates = "wwi-02/data-generators/generator-date.csv"
                customer = "wwi-02/data-generators/generator-customer.csv"
        }

        foreach ($singleFile in $singleFiles.Keys) {
                $source = $publicDataUrl + $singleFiles[$singleFile]
                $destination = $dataLakeStorageBlobUrl + $singleFiles[$singleFile] + $destinationSasKey
                Write-Information "Copying file $($source) to $($destination)"
                & $azCopyCommand copy $source $destination 
        }

        Write-Information "Copying sample sales raw data directories from the public data account..."

        $dataDirectories = @{
                salesmall2014 = "wwi-02,wwi-02/sale-small/Year=2014"
                salesmall2015 = "wwi-02,wwi-02/sale-small/Year=2015"
                salesmall2016 = "wwi-02,wwi-02/sale-small/Year=2016"
                salesmall2017 = "wwi-02,wwi-02/sale-small/Year=2017"
                salesmall2018 = "wwi-02,wwi-02/sale-small/Year=2018"
                salesmall2019 = "wwi-02,wwi-02/sale-small/Year=2019"
                salespoc = "wwi-02,wwi-02/sale-poc/"
        }

        foreach ($dataDirectory in $dataDirectories.Keys) {

                $vals = $dataDirectories[$dataDirectory].tostring().split(",");

                $source = $publicDataUrl + $vals[1];

                $path = $vals[1];

                $destination = $dataLakeStorageBlobUrl + $path + $destinationSasKey
                Write-Information "Copying directory $($source) to $($destination)"
                & $azCopyCommand copy $source $destination --recursive=true
        }
}

Write-Information "Start the $($sqlPoolName) SQL pool if needed."

$result = Get-SQLPool -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName
if ($result.properties.status -ne "Online") {
    Set-SqlPool -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName -Action resume
    Wait-ForSQLPool -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName -TargetStatus Online
}

Write-Information "Create SQL logins in master SQL pool"

$params = @{ PASSWORD = $sqlPassword }
$result = Invoke-SqlScriptFile -SQLScriptsPath $sqlScriptsPath -WorkspaceName $workspaceName -SQLPoolName "master" -FileName "01-create-logins" -Parameters $params
$result

Write-Information "Create SQL users and role assignments in $($sqlPoolName)"

$params = @{ USER_NAME = $userName }
$result = Invoke-SqlScriptFile -SQLScriptsPath $sqlScriptsPath -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName -FileName "02-create-users" -Parameters $params
$result

Write-Information "Create schemas in $($sqlPoolName)"

$params = @{}
$result = Invoke-SqlScriptFile -SQLScriptsPath $sqlScriptsPath -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName -FileName "03-create-schemas" -Parameters $params
$result

Write-Information "Create tables in the [wwi] schema in $($sqlPoolName)"

$params = @{}
$result = Invoke-SqlScriptFile -SQLScriptsPath $sqlScriptsPath -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName -FileName "04-create-tables-in-wwi-schema" -Parameters $params
$result


Write-Information "Create linked service for SQL pool $($sqlPoolName) with user asa.sql.admin"

$linkedServiceName = $sqlPoolName.ToLower()
$result = New-SqlPoolKeyVaultLinkedService -TemplatesPath $templatesPath -WorkspaceName $workspaceName -Name $linkedServiceName -DatabaseName $sqlPoolName `
                 -UserName "asa.sql.admin" -KeyVaultLinkedServiceName $keyVaultName -SecretName $keyVaultSQLUserSecretName
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

Write-Information "Create linked service for SQL pool $($sqlPoolName) with user asa.sql.highperf"

$linkedServiceName = "$($sqlPoolName.ToLower())_highperf"
$result = New-SqlPoolKeyVaultLinkedService -TemplatesPath $templatesPath -WorkspaceName $workspaceName -Name $linkedServiceName -DatabaseName $sqlPoolName `
                 -UserName "asa.sql.highperf" -KeyVaultLinkedServiceName $keyVaultName -SecretName $keyVaultSQLUserSecretName
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

<# Day 1-3#>

Write-Information "Create data sets for data load in SQL pool $($sqlPoolName)"

$loadingDatasets = @{
        wwi02_date_adls = $dataLakeAccountName
        wwi02_product_adls = $dataLakeAccountName
        wwi02_sale_small_adls = $dataLakeAccountName
        wwi02_date_asa = $sqlPoolName.ToLower()
        wwi02_product_asa = $sqlPoolName.ToLower()
        wwi02_sale_small_asa = "$($sqlPoolName.ToLower())_highperf"
}

foreach ($dataset in $loadingDatasets.Keys) {
        Write-Information "Creating dataset $($dataset)"
        $result = New-Dataset -DatasetsPath $datasetsPath -WorkspaceName $workspaceName -Name $dataset -LinkedServiceName $loadingDatasets[$dataset]
        Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId
}

Write-Information "Create pipeline to load the SQL pool"

$params = @{
        BLOB_STORAGE_LINKED_SERVICE_NAME = $blobStorageAccountName
}
$loadingPipelineName = "Setup - Load SQL Pool (global)"
$fileName = "load_sql_pool_from_data_lake"

Write-Information "Creating pipeline $($loadingPipelineName)"

$result = New-Pipeline -PipelinesPath $pipelinesPath -WorkspaceName $workspaceName -Name $loadingPipelineName -FileName $fileName -Parameters $params
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

Write-Information "Running pipeline $($loadingPipelineName)"

$result = Start-Pipeline -WorkspaceName $workspaceName -Name $loadingPipelineName
$result = Wait-ForPipelineRun -WorkspaceName $workspaceName -RunId $result.runId
$result

Confirm-ValidTokens

Write-Information "Deleting pipeline $($loadingPipelineName)"

$result = Remove-ASAObject -WorkspaceName $workspaceName -Category "pipelines" -Name $loadingPipelineName
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

foreach ($dataset in $loadingDatasets.Keys) {
        Write-Information "Deleting dataset $($dataset)"
        $result = Remove-ASAObject -WorkspaceName $workspaceName -Category "datasets" -Name $dataset
        Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId
}

<# POC - Day 4 - Must be run after Day 3 content/pipeline loads#>

Write-Information "Create wwi_poc schema and tables in $($sqlPoolName)"

$params = @{}
$result = Invoke-SqlScriptFile -SQLScriptsPath $sqlScriptsPath -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName -FileName "16-create-poc-schema" -Parameters $params
$result

Write-Information "Create the [wwi_poc.Sale] table in SQL pool $($sqlPoolName)"

$result = Invoke-SqlScriptFile -SQLScriptsPath $sqlScriptsPath -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName -FileName "17-create-wwi-poc-sale-heap" -Parameters $params
$result

Write-Information "Create data sets for PoC data load in SQL pool $($sqlPoolName)"

$loadingDatasets = @{
        wwi02_poc_customer_adls = $dataLakeAccountName
        wwi02_poc_customer_asa = $sqlPoolName.ToLower()
}

foreach ($dataset in $loadingDatasets.Keys) {
        Write-Information "Creating dataset $($dataset)"
        $result = New-Dataset -DatasetsPath $datasetsPath -WorkspaceName $workspaceName -Name $dataset -LinkedServiceName $loadingDatasets[$dataset]
        Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId
}

Write-Information "Create pipeline to load PoC data into the SQL pool"

$params = @{
        BLOB_STORAGE_LINKED_SERVICE_NAME = $blobStorageAccountName
}
$loadingPipelineName = "Setup - Load SQL Pool"
$fileName = "import_poc_customer_data"

Write-Information "Creating pipeline $($loadingPipelineName)"

$result = New-Pipeline -PipelinesPath $pipelinesPath -WorkspaceName $workspaceName -Name $loadingPipelineName -FileName $fileName -Parameters $params
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

Write-Information "Running pipeline $($loadingPipelineName)"

$result = Start-Pipeline -WorkspaceName $workspaceName -Name $loadingPipelineName
$result = Wait-ForPipelineRun -WorkspaceName $workspaceName -RunId $result.runId
$result

Write-Information "Deleting pipeline $($loadingPipelineName)"

$result = Remove-ASAObject -WorkspaceName $workspaceName -Category "pipelines" -Name $loadingPipelineName
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

foreach ($dataset in $loadingDatasets.Keys) {
        Write-Information "Deleting dataset $($dataset)"
        $result = Remove-ASAObject -WorkspaceName $workspaceName -Category "datasets" -Name $dataset
        Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId
}

