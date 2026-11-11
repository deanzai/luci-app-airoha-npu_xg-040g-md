# rollback.ps1: 一键完全还原与无残留卸载脚本
$target = "192.168.13.254"
$sshUser = "root"

Write-Host "=== 正在完全还原设备 $target 状态 ===" -ForegroundColor Yellow

$remoteCmd = @'
rm -f /usr/libexec/rpcd/luci.airoha_npu
rm -f /usr/share/luci/menu.d/luci-app-airoha-npu.json
rm -f /usr/share/rpcd/acl.d/luci-app-airoha-npu.json
rm -rf /www/luci-static/resources/view/airoha_npu
rm -rf /tmp/luci-indexcache /tmp/luci-modulecache/
/etc/init.d/rpcd restart
echo "ROLLBACK_SUCCESS"
'@

ssh "${sshUser}@${target}" $remoteCmd

Write-Host "=== 还原完成，所有插件文件与临时缓存已彻底清理 ===" -ForegroundColor Green
