# backup.ps1: 状态基线与备份脚本
$target = "192.168.13.254"
$sshUser = "root"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "C:\Users\Administrator\Documents\luci-app-airoha-npu\backups\backup_$timestamp"

New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
Write-Host "=== 正在记录系统基准状态至 $backupDir ===" -ForegroundColor Cyan

$sysInfo = ssh "${sshUser}@${target}" @"
echo "--- UPTIME ---"
uptime
echo "--- PS ---"
ps | grep -E 'netifd|firewall|dnsmasq|uhttpd|rpcd'
echo "--- CPUFREQ ---"
cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq
cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo "--- IP ADDR ---"
ip -br addr
"@

$sysInfo | Out-File -FilePath "$backupDir\baseline_system_status.txt" -Encoding utf8
Write-Host "=== 系统基线备份完成 ===" -ForegroundColor Green
