# deploy.ps1: 安全部署脚本
$target = "192.168.13.254"
$sshUser = "root"

Write-Host "=== 1. 创建目标目录 ===" -ForegroundColor Cyan
ssh "${sshUser}@${target}" "mkdir -p /usr/libexec/rpcd /usr/share/luci/menu.d /usr/share/rpcd/acl.d /www/luci-static/resources/view/airoha_npu"

Write-Host "=== 2. 上传 rpcd 后端与配置 ===" -ForegroundColor Cyan
scp.exe -O root/usr/libexec/rpcd/luci.airoha_npu "${sshUser}@${target}:/usr/libexec/rpcd/luci.airoha_npu"
scp.exe -O root/usr/share/luci/menu.d/luci-app-airoha-npu.json "${sshUser}@${target}:/usr/share/luci/menu.d/luci-app-airoha-npu.json"
scp.exe -O root/usr/share/rpcd/acl.d/luci-app-airoha-npu.json "${sshUser}@${target}:/usr/share/rpcd/acl.d/luci-app-airoha-npu.json"

Write-Host "=== 3. 上传前端视图文件 ===" -ForegroundColor Cyan
scp.exe -O htdocs/luci-static/resources/view/airoha_npu/status.js "${sshUser}@${target}:/www/luci-static/resources/view/airoha_npu/status.js"

Write-Host "=== 4. 设置权限并刷新服务 ===" -ForegroundColor Cyan
ssh "${sshUser}@${target}" "chmod +x /usr/libexec/rpcd/luci.airoha_npu && rm -rf /tmp/luci-indexcache /tmp/luci-modulecache/ && /etc/init.d/rpcd restart"
Start-Sleep -Seconds 1

Write-Host "=== 部署完成 ===" -ForegroundColor Green
