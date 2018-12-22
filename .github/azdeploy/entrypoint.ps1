$null = Find-Module -Name Az | Install-Module -Force

$secpasswd = ConvertTo-SecureString $env:SERVICE_PASS -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($env:SERVICE_PRINCIPAL, $secpasswd)

Add-AzAccount -ServicePrincipal -Credential $Credential -Tenant $env:TENANT_ID

$location = "eastus"
$rgName = "$($env:APPID)-rg"
$planName = "$($env:APPID)-plan"

New-AzResourceGroup -Name $rgName -Location $location -Force
New-AzAppServicePlan -ResourceGroupName $rgName -Name $planName -Location $location
New-AzWebApp -ResourceGroupName $rgName -Location $location -AppServicePlan $planName -Name $env:APPID

[xml]$webappProfile = Get-AzWebAppPublishingProfile -Name $env:APPID -ResourceGroupName $rgName
$msdeploy = $webappProfile.publishData.publishProfile | Where-Object {$_.publishmethod -eq 'MSDeploy'}
$remote = "https://$($msdeploy.userName):$($msdeploy.userPWD)@${env:APPID}.scm.azurewebsites.net/${env:APPID}.git"

git remote add azure $remote
git push azure master