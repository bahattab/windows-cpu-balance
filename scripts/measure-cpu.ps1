param([ValidateRange(2,60)][int]$Seconds=8, [switch]$AsJson)
$ErrorActionPreference='Stop'
try {
    $logical=[int](Get-CimInstance Win32_Processor | Measure-Object NumberOfLogicalProcessors -Sum).Sum
    if($logical -lt 1){throw 'Cannot determine machine logical CPU count.'}
    $clock=[Diagnostics.Stopwatch]::StartNew()
    $previous=@{}
    $unavailable=0
    Get-Process | ForEach-Object {
        try { $previous[$_.Id]=@{CPU=[double]$_.CPU;Start=$_.StartTime.Ticks;Time=$clock.Elapsed.TotalSeconds} }
        catch { $unavailable++ }
    }
    Start-Sleep -Seconds $Seconds
    $rows=@(Get-Process | ForEach-Object {
        try {
            $currentCPU=[double]$_.CPU
            $at=$clock.Elapsed.TotalSeconds
            $old=$previous[$_.Id]
            if($old -and $old.Start -eq $_.StartTime.Ticks){
                $duration=$at-$old.Time
                $path=$null
                try {$path=$_.Path} catch {}
                if($duration -gt 0){
                    [pscustomobject]@{Name=$_.ProcessName;PID=$_.Id;CPUPercent=[Math]::Round([Math]::Max(0,100*($currentCPU-$old.CPU)/$duration/$logical),2);SampleSeconds=[Math]::Round($duration,2);RAM_MB=[Math]::Round($_.WorkingSet64/1MB);Path=$path}
                }
            }
        } catch { $unavailable++ }
    })
    $current=@(Get-Process)
    $threadTotal=0
    $owners=@($current | ForEach-Object {
        try {
            $count=$_.Threads.Count
            $threadTotal+=$count
            [pscustomobject]@{Name=$_.ProcessName;PID=$_.Id;Threads=$count}
        } catch { $unavailable++ }
    })
    $groups=@($current | Group-Object ProcessName | Sort-Object Count -Descending | Select-Object -First 20 @{n='Name';e={$_.Name}},Count)
    $report=[pscustomobject]@{LogicalProcessors=$logical;RequestedSleepSeconds=$Seconds;ProcessCount=$current.Count;ThreadCount=$threadTotal;InaccessibleObservations=$unavailable;ProcessesByName=$groups;TopThreadOwners=@($owners | Sort-Object Threads -Descending | Select-Object -First 15);Processes=@($rows | Sort-Object CPUPercent -Descending | Select-Object -First 20)}
    if($AsJson){$report|ConvertTo-Json -Depth 5}else{$report.Processes; Write-Verbose "Machine CPUs: $logical; inaccessible observations: $unavailable"}
} catch { Write-Error $_.Exception.ToString(); exit 1 }
