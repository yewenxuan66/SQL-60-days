<#
=====================================================================
 daily-commit.ps1  ·  SQL 60 天计划的一键提交脚本
 放在仓库的 tools\ 目录下。作用：把「add + commit + push」三步合成一步，
 并且自动生成规范的提交信息（D序号: 主题）。

 用法（在仓库任意位置打开 PowerShell 都行）：
   .\tools\daily-commit.ps1 -Day 1 -Msg "示例库导入 + SQL快速入门10题"
   .\tools\daily-commit.ps1 -Day 2                       # Msg 省略时用默认值
   .\tools\daily-commit.ps1 -Day 2 -NoPush               # 只本地提交，不推送
   .\tools\daily-commit.ps1 -Day 3 -Msg "NULL专题" -Dry  # 只看会提交什么，不真提交

 如果提示"禁止运行脚本"，先执行一次：
   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
=====================================================================
#>
param(
  [Parameter(Mandatory = $true)][int]$Day,
  [string]$Msg = "当日练习",
  [switch]$NoPush,
  [switch]$Dry
)

$ErrorActionPreference = "Stop"
# 脚本在 tools\ 下，上一层就是仓库根目录
$repo = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repo

$label   = "D" + $Day
$message = $label + ": " + $Msg

Write-Host ""
Write-Host ("仓库目录 : " + $repo) -ForegroundColor Cyan
Write-Host ("提交信息 : " + $message) -ForegroundColor Cyan
Write-Host ""

# ---------- 第 1 步：git add -A ----------
# -A = all，把工作区所有改动（新增/修改/删除）全部放进暂存区
git add -A
if ($LASTEXITCODE -ne 0) { Write-Host "git add 失败，请检查上面的报错。" -ForegroundColor Red; exit 1 }

# ---------- 第 2 步：看看这次到底要提交什么 ----------
$status = git status --porcelain
if (-not $status) {
  Write-Host "没有需要提交的改动（工作区是干净的）。" -ForegroundColor Yellow
  exit 0
}
Write-Host "--- 本次将提交的文件 ---" -ForegroundColor Gray
$status | ForEach-Object { Write-Host ("  " + $_) }
Write-Host ("共 " + ($status | Measure-Object).Count + " 项改动") -ForegroundColor Gray
Write-Host ""

if ($Dry) {
  Write-Host "[Dry 模式] 已经 git add，但没有 commit。想撤销暂存： git reset" -ForegroundColor Yellow
  exit 0
}

# ---------- 第 3 步：git commit ----------
git commit -m $message
if ($LASTEXITCODE -ne 0) {
  Write-Host "提交失败。常见原因：git 身份没配。执行：" -ForegroundColor Red
  Write-Host '  git config --global user.name "你的名字"'
  Write-Host '  git config --global user.email "你的邮箱"'
  exit 1
}

if ($NoPush) {
  Write-Host "已本地提交（未推送，因为你加了 -NoPush）。稍后可手动 git push" -ForegroundColor Green
  git log --oneline -3
  exit 0
}

# ---------- 第 4 步：git push ----------
Write-Host ""
Write-Host "--- 推送到 GitHub ---" -ForegroundColor Gray
git push
if ($LASTEXITCODE -ne 0) {
  Write-Host ""
  Write-Host "推送失败。三种常见原因：" -ForegroundColor Red
  Write-Host "  1) 网络问题（GitHub 在国内偶尔连不上）→ 稍后重试 git push"
  Write-Host "  2) 凭据过期 → 控制面板 > 凭据管理器 > Windows 凭据，删掉 git:https://github.com 再重推，会弹出登录"
  Write-Host "  3) 远程有你本地没有的提交 → 先 git pull --rebase 再 git push"
  exit 1
}

Write-Host ""
Write-Host "=== 完成 ===" -ForegroundColor Green
git log --oneline -3
Write-Host ""
Write-Host "去刷新看看： https://github.com/yewenxuan66/SQL-60-days" -ForegroundColor Green
Write-Host ("绿格子应该多了一格： " + (Get-Date -Format "yyyy-MM-dd")) -ForegroundColor Green
