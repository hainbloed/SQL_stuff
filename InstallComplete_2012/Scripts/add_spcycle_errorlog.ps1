param(
[string]$ServerInstance=$(Throw "Paramter fehlt: -ServerInstance Server\Instanz")
##[string]$ServerInstance= "SM03893\S042"
)
Set PS-Debug-Strict 

function main
{

# create a server connection

$server=New-Object Microsoft.SqlServer.Management.Smo.Server($ServerInstance)
 
# create job
$jobName =  "DBA Job `'Cycle_Errorlogs`'"

$Server = New-Object('Microsoft.SQLServer.Management.SMO.Server')("$ServerInstance")
$jobs = $Server.JobServer.Jobs
foreach ($job in $jobs)
        {if ($job.Name -like $jobname){ $check_job = 1;  Write-Host -ForegroundColor Yellow "Job $jobname already exists"}}

if ($check_job -ne 1)
{
$job = New-Object Microsoft.SqlServer.Management.SMO.Agent.Job($server.JobServer, $jobName) 
$job.Description = "Create a new errorlog daily at 0 p.m."
$job.OwnerLoginName = "sa"
$job.Create()
$job.ApplyToTargetServer($ServerInstance)

 

	$jobstep = New-Object('Microsoft.SqlServer.Management.SMO.Agent.JobStep')($job, "Cycle Log")
	$jobStep.Subsystem = [Microsoft.SqlServer.Management.Smo.Agent.AgentSubSystem]::TransactSql
	$jobstep.Command = "exec sp_cycle_errorlog;
GO
Use MSDB;
exec sp_cycle_agent_errorlog;
GO"
	$jobstep.OnSuccessAction = [Microsoft.SqlServer.Management.SMO.Agent.StepCompletionAction]::GoToNextStep;
	$jobstep.OnFailAction =[Microsoft.SqlServer.Management.SMO.Agent.StepCompletionAction]::GoToNextStep; 
	$jobstep.Create()
	
	$jobstep = New-Object('Microsoft.SqlServer.Management.SMO.Agent.JobStep')($job, "Purge_jobhistory")
	$jobStep.Subsystem = [Microsoft.SqlServer.Management.Smo.Agent.AgentSubSystem]::TransactSql
	$jobstep.Command = "declare @date as datetime
set @date = getdate()-90
EXEC msdb.dbo.sp_purge_jobhistory  @oldest_date=@date
GO"
	$jobstep.OnSuccessAction = [Microsoft.SqlServer.Management.SMO.Agent.StepCompletionAction]::GoToNextStep;
	$jobstep.OnFailAction =[Microsoft.SqlServer.Management.SMO.Agent.StepCompletionAction]::GoToNextStep; 
	$jobstep.Create()
	
	$jobstep = New-Object('Microsoft.SqlServer.Management.SMO.Agent.JobStep')($job, "Purge_backuphistory")
	$jobStep.Subsystem = [Microsoft.SqlServer.Management.Smo.Agent.AgentSubSystem]::TransactSql
	$jobstep.Command = "declare @oldest_date as datetime
set @oldest_date = getdate()-90
EXEC msdb.dbo.sp_delete_backuphistory @oldest_date
GO"
	$jobstep.OnSuccessAction = [Microsoft.SqlServer.Management.SMO.Agent.StepCompletionAction]::QuitWithSuccess;
	$jobstep.OnFailAction =[Microsoft.SqlServer.Management.SMO.Agent.StepCompletionAction]::QuitWithFailure; 
	$jobstep.Create()
	
	$jobschd =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Agent.JobSchedule -argumentlist $job, "Daily 0 p.m." 
	$jobschd.FrequencyTypes =  [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Daily
	$ts1 =  New-Object -TypeName TimeSpan -argumentlist 0, 0, 0
	$jobschd.ActiveStartTimeOfDay = $ts1
	$jobschd.FrequencyInterval = 1
	$culture = New-Object System.Globalization.CultureInfo("en-US")
	$jobschd.ActiveStartDate = (Get-Date).tostring("d",$culture)
	$jobschd.create()
Write-Host -ForegroundColor Green "Job $jobname created"
}
}

main