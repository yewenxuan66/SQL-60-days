#!/usr/bin/env bash
# =====================================================================
#  daily-commit.sh  ·  SQL 60 天计划一键提交脚本（Git Bash 版）
#
#  用法（在仓库里打开 Git Bash）：
#     bash tools/daily-commit.sh 1 "导入示例库 + SQL快速入门10题"
#     bash tools/daily-commit.sh 2 "DISTINCT/LIKE/分页 + 牛客11-24"
#     bash tools/daily-commit.sh 3 "NULL三值逻辑专题"
#
#  它做的事： git add -A  →  git commit -m "D天数: 说明"  →  git push
# =====================================================================

DAY="$1"
MSG="$2"

if [ -z "$DAY" ]; then
  echo ""
  echo "用法: bash tools/daily-commit.sh <天数> \"<提交说明>\""
  echo "例子: bash tools/daily-commit.sh 1 \"导入示例库 + SQL快速入门10题\""
  echo ""
  exit 1
fi
if [ -z "$MSG" ]; then
  MSG="当日练习"
fi

# 切到仓库根目录（本脚本在 tools/ 下）
cd "$(dirname "$0")/.." || exit 1

MESSAGE="D${DAY}: ${MSG}"

echo ""
echo "仓库目录 : $(pwd)"
echo "提交信息 : ${MESSAGE}"
echo ""

git add -A

if git diff --cached --quiet; then
  echo "没有需要提交的改动，工作区是干净的。"
  exit 0
fi

echo "--- 本次将提交的文件 ---"
git status --porcelain
echo ""

git commit -m "${MESSAGE}"
if [ $? -ne 0 ]; then
  echo ""
  echo "提交失败。最常见原因是 git 身份没配，执行这两行后重试："
  echo '  git config --global user.name  "yewenxuan"'
  echo '  git config --global user.email "3220837805@qq.com"'
  exit 1
fi

echo ""
echo "--- 推送到 GitHub ---"
git push
if [ $? -ne 0 ]; then
  echo ""
  echo "推送失败，三种常见原因："
  echo "  1) 网络问题（GitHub 偶尔连不上）→ 过几分钟重试  git push"
  echo "  2) 远程有你本地没有的提交 → 先 git pull --rebase 再 git push"
  echo "  3) 凭据过期 → 控制面板 > 凭据管理器 > Windows 凭据，删掉 git:https://github.com 再重推"
  exit 1
fi

echo ""
echo "=== 完成 ==="
git log --oneline -3
echo ""
echo "去刷新看看: https://github.com/yewenxuan66/SQL-60-days"
echo "今天日期: $(date +%Y-%m-%d)  绿格子应该多了一格"