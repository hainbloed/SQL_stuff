
param([string]$ServerInstance=$(Throw "Instanzname fehlt!"))
 
	Set PS-Debug-Strict 
	$DebugPreference="SilentlyContinue"

function checkSQLServer
# checks availability of SQL-Service
{
$Error.Clear()
trap{write-host -ForegroundColor Red "Please check instancename and availability of the SQL-Service!";Continue}
	
	& {
	$sqlCon = New-Object Data.SqlClient.SqlConnection
	$sqlCon.ConnectionString = "Data Source=$ServerInstance;Integrated Security=True"
	$sqlCon.open()
	}
if ($Error.Count -ne 0){break}
}

function checkAgent
# verifys if varibale agent service has a value
{
$Error.Clear()
trap{Write-Host -ForegroundColor Red "SQL-Agent could not be found - is the service running?";Continue}
	& {
    $SMOServer = New-Object('Microsoft.SQLServer.Management.SMO.Server')("$ServerInstance")
    $LocalHostAlias = $SMOServer.JobServer.Name
	If (!($Name)){throw}
	}
if ($Error.Count -ne 0){break}
}


function main
{
checkSQLServer
##checkAgent
# create a server connection

# check and create job
$jobName =  "DBA Job `'DC19_out`'"

$Server = New-Object('Microsoft.SQLServer.Management.SMO.Server')("$ServerInstance")
$jobs = $Server.JobServer.Jobs
foreach ($job in $jobs)
        {if ($job.Name -like $jobname){ $check_job = 1;  Write-Host -ForegroundColor Yellow "Job $jobname already exists"}}

if ($check_job -ne 1)
{
$job = New-Object Microsoft.SqlServer.Management.Smo.Agent.Job
$job = New-Object Microsoft.SqlServer.Management.SMO.Agent.Job($server.JobServer, $jobName) 
$job.Description = "Create a new DC19 report weekly at 0 p.m."
$job.OwnerLoginName = "sa"
$job.Create()
$job.ApplyToTargetServer($ServerInstance)

 

	$jobstep = New-Object('Microsoft.SqlServer.Management.SMO.Agent.JobStep')($job, "DC19_out")
	$jobStep.Subsystem = [Microsoft.SqlServer.Management.Smo.Agent.AgentSubSystem]::TransactSql
	$jobstep.Command = @"
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO
if not exists(
    SELECT value
    FROM sys.configurations
    WHERE name = 'xp_cmdshell'
     and value = 1
)
begin
    exec sp_configure @configname=xp_cmdshell, @configvalue=1
    reconfigure
end
declare @sql varchar(4000)
declare @bcp varchar(4000)
declare @servername varchar(256)
declare @instancename varchar(256)
declare @path varchar(256)
declare @filename varchar(256)
declare @server varchar(256)


set @servername = convert(varchar,SERVERPROPERTY('MachineName'))
set @instancename = isnull(convert(varchar,SERVERPROPERTY('InstanceName')),'STD')
set @path = 'C:\temp\'
set @filename = @servername+'_'+@instancename+'.csv'

set @server = (case  when @instancename = 'STD' then @servername else  @servername+'\'+@instancename end)

set @sql = 'SELECT '''+ @servername+''' AS [servername], p.[name], l.[sysadmin] AS	[sysadmin], p.[create_date], p.[modify_date], p.[type], p.[is_disabled], l.[denylogin], case when l.[isntname] = 1 and l.[isntgroup] = 0 then ''Windows account'' 	when l.[isntname] = 1 and l.[isntgroup] = 1 then ''Windows group'' 	else ''SQL login'' end as [authentication type] ,l.[sid] FROM sys.server_principals p left join sys.syslogins l on p.sid = l.sid where l.sysadmin = 1'
set @bcp = 'bcp "'+@sql+'" queryout '+@path+@filename+' -c -t; -T -S'+ @server

print @bcp

exec master..xp_cmdshell @bcp
"@
	$jobstep.OnSuccessAction = [Microsoft.SqlServer.Management.SMO.Agent.StepCompletionAction]::QuitWithSuccess;
	$jobstep.OnFailAction =[Microsoft.SqlServer.Management.SMO.Agent.StepCompletionAction]::QuitWithFailure; 
	$jobstep.Create()
	
	$jobschd =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Agent.JobSchedule -argumentlist $job, "Weekly 0 p.m." 
	$jobschd.FrequencyTypes =  [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Weekly
	$jobschd.FrequencyInterval = [Microsoft.SqlServer.Management.Smo.Agent.WeekDays]::Sunday
	$jobschd.FrequencyRecurrenceFactor = 1 # Run every 1 week
	$ts1 =  New-Object -TypeName TimeSpan -argumentlist 0, 0, 0
	$jobschd.ActiveStartTimeOfDay = $ts1
	$jobschd.FrequencyInterval = 1
	$culture = New-Object System.Globalization.CultureInfo("en-US")
	$jobschd.ActiveStartDate = (Get-Date).tostring("d",$culture)
	$jobschd.create()

Write-Host -ForegroundColor Green "Job $jobname created"
}}


$mypath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $mypath
main