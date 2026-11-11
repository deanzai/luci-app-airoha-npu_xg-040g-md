# verify.ps1: 验收与校验脚本
$target = "192.168.13.254"
$sshUser = "root"

Write-Host "================ [1] 检查文件部署状态 ================" -ForegroundColor Cyan
ssh "${sshUser}@${target}" "ls -la /usr/libexec/rpcd/luci.airoha_npu /usr/share/luci/menu.d/luci-app-airoha-npu.json /usr/share/rpcd/acl.d/luci-app-airoha-npu.json /www/luci-static/resources/view/airoha_npu/status.js"

Write-Host "`n================ [2] 检查 ubus rpcd 服务注册 ================" -ForegroundColor Cyan
ssh "${sshUser}@${target}" "ubus list | grep luci.airoha_npu"

Write-Host "`n================ [3] 检查 getStatus 状态读取 ================" -ForegroundColor Cyan
$statusJson = ssh "${sshUser}@${target}" "ubus call luci.airoha_npu getStatus"
Write-Host $statusJson

Write-Host "`n================ [4] 检查 getFrameEngine 状态读取 ================" -ForegroundColor Cyan
$feJson = ssh "${sshUser}@${target}" "ubus call luci.airoha_npu getFrameEngine"
Write-Host $feJson

Write-Host "`n================ [5] 检查 Web 静态文件分发 ================" -ForegroundColor Cyan
$httpRes = curl.exe -k -s -o /dev/null -w "%{http_code}" "http://${target}/luci-static/resources/view/airoha_npu/status.js"
Write-Host "HTTP status for status.js: $httpRes"

Write-Host "`n================ [6] 检查核心系统与业务稳定性 ================" -ForegroundColor Cyan
ssh "${sshUser}@${target}" "uptime; cat /proc/loadavg; cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq"

Write-Host "`n=== 校验流程完成 ===" -ForegroundColor Green
