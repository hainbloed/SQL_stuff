# ====================================================================================================
# 
# NAME: create_ini.ps1
# 
# AUTHOR: Holger Voges
# DATE  : 26.07.2012 : Initial release
# 
# COMMENT: 	function-library for Installation_GUI.ps1, replaces create_ini.ps1
#
# =====================================================================================================

function ApplyConfig([string]$configfile)
# Function reads the Configuration-File and returns a hashtable with two arrays, AdminAccount with the valid 
# accounts and NonExistingAccounts with the accounts not found in AD
{
	$ValidCheckBoxValues = "true", "false"
	$ReturnValues = @{}
	$AdminAccounts = @()
	$NotExisitingAccounts = @()
	[xml]$config = Get-Content $configfile
	if ($config.Configuration.Settings.AdminAccount -ne "")
		{
		foreach ($admin in $config.Configuration.Variables.AdminAccount)
			{
			$adminSplit = $admin.split( "\" )
			if (Find_User $adminSplit[1] (get_dom $adminSplit[0]).ldap)
				{ $AdminAccounts += $admin }
			else 
				{ $NotExistingAccounts += $admin }
			}
			$ReturnValues.Add( "NotExisitingAccounts", $NotExisitingAccounts )
			$ReturnValues.Add( "AdminAccounts", $AdminAccounts )
			Return $ReturnValues
		} 
	else 
		{
		 $ReturnValues.Add( "NotExistingAccounts", "Configurationfile has no Admin-Accounts set. Defaults will be used`r`n" )
		 return $ReturnValues
		}
}

Function Get_Dom( [string]$Dom )
	# gets domain of the computer-account and returns a hash-field with domain in FQDN and LADP-Format.
	{
	$domstring=@{}
	$forest = [System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest()
	$Domain = $forest.domains | Where-Object {$_.name -like "$Dom*"}
	if ($domain)
	{
		$domstring["LDAP"] = "LDAP://" + ($domain.getDirectoryEntry()).distinguishedName # beide Werte mit Return zurückgeben
		$domstring["FQDN"] = $Domain.name
	}
	else
	{
	$Domain = $forest.GetAllTrustRelationships() | ForEach-Object {$_.TrustedDomainInformation} | Where-Object {$_.NetBiosName -eq "$Dom"}
	$domstring["FQDN"] = $Domain.DnsName
	$domLDAP = $domstring.FQDN.Split(".") | ForEach-Object {"DC="+$_}
	$domstring["LDAP"] = "LDAP://" + [System.String]::Join(",",$domLDAP)
	}
		return $domstring
	}
	
Function Find_User($username,[string]$userDom)
	# functions searches for accounts in AD (user, security-groups), parameter $userdom must be in LDAP-Format
	# (grouptype:1.2.840.113556.1.4.803:=-2147483640) = Universal security groups
	# (grouptype:1.2.840.113556.1.4.803:=-2147483646) = global security groups
	# (samaccounttype=536870912) = local security groups
	{
	$Searcher=New-Object directoryServices.DirectorySearcher([ADSI]"$userdom")
	$Searcher.filter ="(&(|(objectClass=user)((objectcategory=group)`
	(|(grouptype:1.2.840.113556.1.4.803:=-2147483640)(grouptype:1.2.840.113556.1.4.803:=-2147483646)(samaccounttype=536870912))))(sAMAccountName=$username))"
	$Searcher.findall()
	}
	
function add_tools()
	{
	# not implemented
	}

function create_setupini()
	{
	}

function add_body($PCU, $CU, $x64)
	{
	$script= @"
; MSSQL-Server-Configuration-File for Installation of $((dir env:computername).value)\$InstanceName
; Creation-Date: $(get-date)
; Creator: $((dir env:Username).value)
; Version: $MSSQLVersion
[$SQLString]
Action="Install"
HELP="False"
INDICATEPROGRESS="False"
QUIET="False"
QUIETSIMPLE="True"
ERRORREPORTING="False"
INSTALLSHAREDDIR="$SQLBinDir"
INSTANCEDIR="$SQLBinDir"
SQMREPORTING=False
ENABLERANU="False"`r`n
"@
	if ($PCU)
		{$ini += "PCUSOURCE =`"$InstallDrive\$installFolder\$SQLSourceFolder\PCU`"`r`n"}
	if ($CU)
		{$ini += "CUSOURCE = `"$InstallDrive\$installFolder\$SQLSourceFolder\CU`"`r`n"}
	if ($X64)
		{$ini += "INSTALLSHAREDWOWDIR=`"$SQLBinDirWOW`"`r`n"}

	}



function add_IS()
	{
	$script:ini+=@"
ISSVCSTARTUPTYPE="Manual"
ISSVCACCOUNT=""
ISSVCPASSWORD=""`r`n
"@
	}

function add_RS()
	{
	if (!$SQLEngine)
		{$script:ini+=@"
INSTANCEID="R$InstanceName"
INSTANCENAME="R$InstanceName"
"@
		}
	
	$script:ini+=@"
RSSVCACCOUNT="NETWORK SERVICE"
RSSVCSTARTUPTYPE="Automatic"
RSINSTALLMODE="FilesOnlyMode"
;FARMADMINPORT="0"
RSSVCPASSWORD=""`r`n 
"@
	}

function add_AS()
	{
	if (!$SQLEngine)
		{INSTANCENAME="$InstanceName"}
	$script:ini+=@"
ASSVCACCOUNT=""
ASSVCSTARTUPTYPE="Automatic"
ASSVCPASSWORD=""
ASCOLLATION=""
ASDATADIR=""
ASLOGDIR=""
ASBACKUPDIR=""
ASTEMPDIR=""
ASCONFIGDIR=""
ASPROVIDERMSOLAP="1"
ASSYSADMINACCOUNTS=""`r`n
"@
	}
	
function create_installps1
	# Creates the powershell setup-file which starts the installation
	{
	Switch ($MSSQLVersion)
		{
		"MSSQL 2005"	{$logPath="C:\Program Files\Microsoft SQL Server\90\Setup Bootstrap\Log"}
		"MSSQL 2008"	{$logPath="C:\Program Files\Microsoft SQL Server\100\Setup Bootstrap\Log"}
		"MSSQL 2008 R2" {$logPath="C:\Program Files\Microsoft SQL Server\100\Setup Bootstrap\Log"}
		"MSSQL 2012" {$logPath="C:\Program Files\Microsoft SQL Server\110\Setup Bootstrap\Log"}
		}
	$setupscript=@"
`# automatically created setup-script for $Serverinstance
param([switch]`$nosetup)

`$mypath = Split-Path -Parent `$MyInvocation.MyCommand.Definition
`$com_auditing=`"`$mypath\Scripts\Install_auditing.ps1 -ServerInstance $Serverinstance`"
`$com_settings=`"`$mypath\Scripts\change_settings.ps1 -ServerInstance $Serverinstance -port $TcpPort`"
`$com_itmv6=`"`$mypath\Scripts\itmV6_config.ps1 -ServerInstance $Serverinstance`"

function main
{if (`$nosetup)
	{
		configure_sql
	 	restore_PendingFileRename
	}
else 
	{setup}
}

function setup
	{
	if (!(test-path `"$InstallDrive\$installFolder\$SQLSourceFolder\setup.exe`"))
		{Return "No Setupfiles found!"}

	If (test-path "$LogPath")
		{`$logBeforeSetup=Get-ChildItem "$logpath"}
	else
		{`$logBeforeSetup=""}
	`$setup=[Diagnostics.process]::start("$InstallDrive\$installFolder\$SQLSourceFolder\setup.exe","/Configurationfile=$InstallDrive\$installFolder\$SetupFolder\unattended.ini")
	`$setup.waitForExit()`r`n

	if (`$setup.exitcode -eq 3010)
		{
		clear_unattended
		If (!(test-path HKCU:Software\Microsoft\Windows\CurrentVersion\RunOnce)){New-Item -PATH HKCU:Software\Microsoft\Windows\CurrentVersion\RunOnce}
		New-ItemProperty HKCU:Software\Microsoft\Windows\CurrentVersion\RunOnce -name "StartConfig" -Value `"`$pshome\powershell.exe `$(`$MyInvocation.MyCommand.Definition) -ServerInstance $Serverinstance -port $TcpPort -notsetup`" -PropertyType string
		write-host -foregroundcolor Green `"Installation successful. Configuration will be resumed after reboot.`"
		}
	elseif (`$setup.exitcode -ne 0)
		{
		if (!(Test-Path `"$logpath`"))
			{
			write-host -foregroundcolor RED `"No Setup-log available. Installation failed with error `" `$setup.exitcode
			Return 
			}
		`$logAfterSetup=Get-ChildItem "$logpath"
		`$setupfiles = Compare-Object `$logAfterSetup `$LogBeforeSetup -Property Name, LastWriteTime -PassThru |
		Where-Object {`$_.sideIndicator -eq '<='}
		`$summary = `$setupfiles | where-object {`$_.name -eq "summary.txt"}
		if (`$summary)
			{notepad.exe `$summary.fullname}
		else 
			{
			`$summary = `$setupfiles | sort-object LastWritetime | select-object -first 1 | 
			foreach {get-childitem `$_.Fullname} | where-object {`$_.name -like "Summary*GlobalRules.txt"}
			notepad.exe `$summary.fullname
			}
		write-host -foregroundcolor RED `"Installation failed with error `" `$setup.exitcode
		Return
	}
	else
	{
		clear_unattended
		if (`$SQLEngine)
			{configure_sql}
		restore_PendingFileRename
	}
	}

function clear_unattended
	{
	`$ini = Get-Content "$InstallDrive\$installFolder\$SetupFolder\unattended.ini"
	foreach (`$line in `$ini)
		{if ((`$line -like "*Password*") -or (`$line -like "SAPWD*"))
			{
			`$line = `$line.Split("=") | Select-Object -First 1
			`$line = `$line + "=***"
			}
		`$newini+=`@(`$line)
		}
	out-File $InstallDrive\$installFolder\$SetupFolder\unattended.ini -InputObject `$newini`r`n
	}

function configure_sql
	{
	Invoke-Expression `$com_auditing -ErrorAction Continue
	Invoke-Expression `$com_settings -ErrorAction Continue
	Invoke-Expression `$com_itmv6 -ErrorAction Continue
	}

function restore_PendingFileRename
	{
	`$key = "HKLM:SYSTEM\CurrentControlSet\Control\Session Manager"
	`$OpenFiles = ((Get-ItemProperty `$key).PendingFileRenameOperations)
	`$Openfiles_PP = ((Get-ItemProperty `$key).PendingFileRenameOperations_PP)
	if (`$Opfenfiles_PP -ne "")
		{
		`$Openfiles += `$Openfiles_PP
		Set-ItemProperty -Path `$key -name PendingFileRenameOperations -value `$OpenFiles
		Remove-ItemProperty `$key PendingFileRenameOperations_PP
		}
	}

Set PS-Debug-Strict
`$DebugPreference = `"SilentlyContinue"
. Main
"@
	$null = Out-File $InstallDrive\$installFolder\$setupFolder\install.ps1 -InputObject $setupscript 
}

function create_InstallFolder
	{
	If (Test-Path $InstallDrive)
		{
		if ((Test-Path $InstallDrive\$installFolder\$SetupFolder))
			{
			create_installps1
			$null = Out-File $InstallDrive\$installFolder\$SetupFolder\unattended.ini -InputObject $ini
			}
		else 
			{
			$null = md $InstallDrive\$installFolder\$SetupFolder
			create_installps1
			$null = Out-File $InstallDrive\$installFolder\$SetupFolder\unattended.ini -InputObject $ini
			}
		If ( !( Test-Path $InstallDrive\$installFolder\$SQLSourceFolder ))
			{ $null = md $InstallDrive\$installFolder\$SQLSourceFolder }
		}	
	Else
		{
		$installDrive = "c:"
		if ( !( Test-Path $InstallDrive\$installFolder\$SetupFolder ))
 			{ $null = md $InstallDrive\$installFolder\$SetupFolder }
 		$null = Out-File $InstallDrive\$installFolder\$SetupFolder\unattended.ini -InputObject $ini
		create_installps1
		}
	copy-Item -Path $mypath -Destination "$InstallDrive\$installFolder\$SetupFolder" -recurse -Exclude "create_ini.ps1"
	}