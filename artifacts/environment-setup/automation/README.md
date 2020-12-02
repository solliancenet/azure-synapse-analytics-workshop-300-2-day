# Environment setup instructions

## Azure Setup

### Task 1: Create a resource group in Azure

1. Log into the [Azure Portal](https://portal.azure.com) using your Azure credentials.

2. On the Azure Portal home screen, select the **+ Create a resource** tile.

    ![A portion of the Azure Portal home screen is displayed with the + Create a resource tile highlighted.](../media/bhol_createaresource.png)

3. In the **Search the Marketplace** text box, type **Resource group** and press the **Enter** key.

    ![On the new resource screen Resource group is entered as a search term.](../media/bhol_searchmarketplaceresourcegroup.png)

4. Select the **Create** button on the **Resource group** overview page.

5. On the **Create a resource group** screen, select your desired Subscription and Region. For Resource group, enter **Synapse-WS-L300**, then select the **Review + Create** button.

    ![The Create a resource group form is displayed populated with Synapse-MCW as the resource group name.](../media/bhol_resourcegroupform.png)

6. Select the **Create** button once validation has passed.

### Task 2: Create Azure Synapse Analytics workspace

1. Deploy the workspace through the following Azure ARM template (press the button below):

    <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsolliancenet%2Fazure-synapse-analytics-workshop-300-2-day%2Fmaster%2Fartifacts%2Fenvironment-setup%2Fautomation%2F00-asa-workspace-core.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png" /></a>

2. On the **Custom deployment** form fill in the fields described below.

* **Subscription**: Select your desired subscription for the deployment.
* **Resource group**: Select the **Synapse-WS-L300** resource group you previously created.
* **Unique Suffix**: This unique suffix will be used naming resources that will created as part of your deployment.
* **SQL Administrator Login Password**: Provide a strong password for the SQLPool that will be created as part of your deployment. Your password will be needed during the next steps. Make sure you have your password noted and secured.
  
    > **Important**: The `location` field under 'Settings' will list the Azure regions where Azure Synapse Analytics (Preview) is available as of July 2020. This will help you find a region where the service is available without being limited to where the resource group is defined.

1. Check the **I agree to the terms and conditions stated above**, then select the **Purchase** button. The provisioning of your deployment resources will take approximately 13 minutes.

    > **Note**: You may experience a deployment step failing in regards to Role Assignment. This error may safely be ignored.

## Path 1: Local PowerShell

### Task 1: Install pre-requisites

1. Install [Windows PowerShell 7](https://docs.microsoft.com/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-7)

    > **Note**: Some of the commands used within the scripts are dependent on PowerShell 7, so you must install this before moving on to the next step.

2. Open Windows PowerShell 7 (x64) and run the following to install the Azure (`az`) PowerShell cmdlets.

    ```powershell
    if (Get-Module -Name AzureRM -ListAvailable) {
        Write-Warning -Message 'Az module not installed. Having both the AzureRM and Az modules installed at the same time is not supported.'
        Uninstall-AzureRm -ea SilentlyContinue
        Install-Module -Name Az -AllowClobber -Scope CurrentUser
    } else {
        Install-Module -Name Az -AllowClobber -Scope CurrentUser
    }
    ```

3. Install the `sqlserver` module

    ```powershell
    Install-Module -Name SqlServer -AllowClobber
    ```

4. Install the Azure CLI

    ```powershell
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
    ```

5. Install VC Redist: <https://aka.ms/vs/15/release/vc_redist.x64.exe>.

6. Install MS ODBC Driver 17 for SQL Server: <https://www.microsoft.com/download/confirmation.aspx?id=56567>.

7. Install SQL CMD x64: <https://go.microsoft.com/fwlink/?linkid=2082790>.

8. Install Microsoft Online Services Sign-In Assistant for IT Professionals RTW: <https://www.microsoft.com/download/details.aspx?id=41950>.

9. Install the [Git client](https://git-scm.com/downloads).

### Task 2: Execute setup scripts

1. From your machine, open a PowerShell Window as an administrator, run the following command to download the artifacts

    ```powershell
    mkdir c:\LabFiles
    ```

2. Create the following file and save it to **C:\LabFiles\AzureCreds.ps1**.

    ```powershell
    $AzureUserName="odl_user_NNNNNN@msazurelabs.onmicrosoft.com"
    $AzurePassword="..."
    $TokenGeneratorClientId="1950a258-227b-4e31-a9cf-717495945fc2"
    $AzureSQLPassword="..."
    ```

    > **Note**
    >
    > The `AzurePassword` value is the password associated with the old_user_NNNNNN account associated with the environment you were provided.
    >
    > The `AzureSQLPassword` value is the value passed to the `sqlAdministratorLoginPassword` parameter when running the `01-asa-workspace-core.json` ARM template. You can find this value by looking at the `SQL-USER_ASA` Key Vault secret.

3. Change the PowerShell directory by running the following from the PowerShell prompt:

    ```PowerShell
    cd C:\LabFiles
    ```

4. Next, clone the workshop's GitHub repo by executing the following:

    ```PowerShell
    git clone https://github.com/solliancenet/azure-synapse-analytics-workshop-300-2-day.git synapse-ws-L300
    ```

5. Run `Set-ExecutionPolicy Unrestricted`.

6. Change the current directory to the **automation** folder of the cloned repository by executing the following:

    ```PowerShell
    cd 'synapse-ws-L300\artifacts\environment-setup\automation'
    ```

7. Execute `Connect-AzAccount` and sign in to the ODL user account when prompted.

8. Execute `./01-environment-setup.ps1`

9. Change the current directory to the **LabFiles** folder of the cloned repository by executing the following:

    ```PowerShell
    cd C:\LabFiles
    ```

10. Execute `.\artifacts\environment-setup\automation\07-01-environment-poc-pre-validate.ps1`

11. Execute `.\artifacts\environment-setup\automation\07-02-environment-poc-validate.ps1`

## Path #2 (Cloud Shell)

> **Important**: Due to the amount of time required to run the environment setup scripts, you will very likely time out on the Cloud Shell before the script completes.

### Task 1: Download artifacts

1. In the Azure Portal, open the Azure Cloud Shell by selecting its icon from the right side of the top toolbar.

    ![A portion of the Azure Portal taskbar is displayed with the Cloud Shell icon highlighted.](../media/bhol_azurecloudshellmenu.png)

    > **Note**: If you are prompted to choose a shell, select **Powershell**, and if asked to create a storage account for the Cloud Shell, agree to have it created.

2. In the Cloud Shell window, enter the following command to clone the repository files.

    ```PowerShell
    git clone https://github.com/solliancenet/azure-synapse-analytics-workshop-300-2-day.git synapse-ws-L300
    ```

    ![The Azure Portal with Cloud shell opened. Git clone command is typed into the cloud shell terminal ready for execution.](../media/cloud-shell-git-clone.png)

3. Keep the Cloud Shell open.

### Task 2: Establish a user context

1. In the Cloud Shell, execute the following command:

    ```cli
    az login
    ```

2. A message will be displayed asking you to open a new tab in your web browser, navigate to [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin) and enter the code you have been given for authentication.

   ![A message is displayed indicating to enter an authentication code on the device login page.](../media/bhol_devicelogin.png)

   ![A dialog is shown requesting the entry of a code.](../media/bhol_clicodescreen.png)

3. Once complete, you may close the tab from the previous step and return to the Cloud Shell.

   ![The JSON result showing the subscription details.](../media/shell-login-result.png)

### Task 3: Run environment setup and validation PowerShell scripts

When executing the scripts below, it is important to let the scripts run to completion. Some tasks may take longer than others to run. When a script completes execution, you will be returned to a command prompt. The total runtime of all steps in this task will take approximately 60 minutes.

1. In the Cloud Shell, change the current directory to the **automation** folder of the cloned repository by executing the following:

    ```PowerShell
    cd './synapse-ws-L300/artifacts/environment-setup/automation'
    ```

2. Execute the environment setup and validation scripts by executing the following commands:

    ```PowerShell
    ./01-environment-setup.ps1
    ```

    > Enter the resource group name when prompted.

    ```PowerShell
    ./07-01-environment-poc-pre-validate.ps1
    ```

    ```PowerShell
    ./07-02-environment-poc-validate.ps1
    ```

    You may be prompted to enter the name of your desired Azure Subscription. You can copy and paste the value from the list to select one.

## Steps & Timing

The entire script will take a little over an hour to complete.  Major steps include:

* Configure Synapse resources
* Download all data sets and files into the data lake (~15 mins)
* Execute the setup and execute the SQL pipeline (~30 mins)
