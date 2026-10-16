-- =====================================================================
--  D5｜NULL 专题 ★ 本周最重要的一天
--  2026-10-23（周五）｜第 1 周｜40 天计划的第 5 天｜5题
--  讲义：第1周_D1-D5_基础查询与NULL.md  →  搜「D5」跳到那一节
-- ---------------------------------------------------------------------
--  45 分钟怎么用：
--    ① 读讲义「二、讲解」                                       20 分钟
--    ② 在下面每题的「你的答案」处写 SQL，选中按 Ctrl+Enter 执行    20 分钟
--    ③ 写完再看讲义里的答案区；错题必须关掉答案重写一遍
--    ④ 写 1 条笔记进 notes/，然后提交：                          5 分钟
--       bash tools/daily-commit.sh 5 "NULL三值逻辑专题 + 5题"
--  ⚠️ 本文件不含答案。答案在讲义里，做完再看。
-- =====================================================================

USE employees;   -- 多数题用 employees 库；题目里写了 learn.xxx 的用 learn 库
                 -- 首次做题前先跑一次：datasets/setup_learn_tables.sql

-- 第1题｜先猜再跑
--        SELECT COUNT(*) AS 行数, COUNT(score) AS 有分数的人数, COUNT(name) AS 有名字的人数
--        FROM learn.nulltest;
--        我猜的三个数字：      /       /
--        实际跑出来的三个数字： /       /
--        为什么不一样？


-- 第2题｜先手工算再跑
--        SELECT AVG(score) FROM learn.nulltest;
--        我手工算的答案（把NULL当缺失，只算有值的）：
--        我手工算的答案（把NULL当0分）：
--        MySQL 实际返回：
--        MySQL 用的是哪种口径？如果我想用另一种，SQL 该怎么写？


-- 第3题｜【核心陷阱题】
--        SELECT * FROM learn.nulltest WHERE score <> 80;
--        返回几行？id=2 和 id=5（score 为 NULL 的那两行）在里面吗？
--        为什么？怎么改写才能把 score 为 NULL 的行也包含进来？


-- 第4题｜用 COALESCE 把查询结果"补干净"
--        查出 id、name、score 三列，要求：name 为 NULL 的显示 '未知'，score 为 NULL 的显示 0


-- 第5题｜防除零
--        SELECT SUM(score) / COUNT(*) FROM learn.nulltest WHERE id > 100;
--        这句会报错吗？返回什么？
--        改成用 NULLIF 保护，让它在没有数据时返回 NULL 而不是报错

-- ===== 做完之后 =====
-- 1) 错题记进 notes/99_我的错题本.md（只记错的）
-- 2) 写 1 条笔记进 notes/W1_*.md
-- 3) 提交：bash tools/daily-commit.sh 5 "NULL三值逻辑专题 + 5题"
