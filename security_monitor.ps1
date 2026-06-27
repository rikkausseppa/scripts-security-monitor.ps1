# REAL-TIME SECURITY LOG MONITOR
# TEAMS + TELEGRAM ALERTS

$TeamsWebhookUrl = "BURAYA_TEAMS_WEBHOOK_URL"
$TelegramBotToken = "BURAYA_TELEGRAM_BOT_TOKEN"
$TelegramChatId   = "BURAYA_TELEGRAM_CHAT_ID"

$CriticalEventIds = @(4625,4728,4720,4769,4771,7045)

function Send-TeamsAlert {
    param([string]$Title,[string]$Message)
    $payload = @{ title = $Title; text = $Message } | ConvertTo-Json
    Invoke-RestMethod -Uri $TeamsWebhookUrl -Method Post -Body $payload -ContentType 'application/json'
}

function Send-TelegramAlert {
    param([string]$Message)
    $url = "https://api.telegram.org/bot$TelegramBotToken/sendMessage"
    $body = @{ chat_id = $TelegramChatId; text = $Message }
    Invoke-RestMethod -Uri $url -Method Post -Body $body
}

$Query = @"
<QueryList>
  <Query Id="0" Path="Security">
    <Select>*[System[(EventID=4625 or EventID=4728 or EventID=4720 or EventID=4769 or EventID=4771 or EventID=7045)]]</Select>
  </Query>
</QueryList>
"@

$Watcher = New-Object System.Diagnostics.Eventing.Reader.EventLogWatcher(
    (New-Object System.Diagnostics.Eventing.Reader.EventLogQuery("Security",[System.Diagnostics.Eventing.Reader.PathType]::LogName,$Query))
)

$Action = {
    param($EventRecord)
    $Time = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $ID   = $EventRecord.Id
    $Machine = $env:COMPUTERNAME
    $AlertText = "[$Time] DC: $Machine → Security EventID: $ID"
    Write-Host $AlertText -ForegroundColor Red
    Send-TeamsAlert -Title "Security Alert on $Machine" -Message $AlertText
    Send-TelegramAlert -Message $AlertText
}

Register-ObjectEvent -InputObject $Watcher -EventName EventRecordWritten -Action $Action | Out-Null
$Watcher.Enabled = $true

Write-Host "Security monitor running with Teams + Telegram alerts..." -ForegroundColor Green

while ($true) { Start-Sleep -Seconds 1 }
