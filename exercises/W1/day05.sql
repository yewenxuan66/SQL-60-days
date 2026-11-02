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
--        为什么不一样？COUNT(*) 数所有行 = 5
--       COUNT(score) 只数 score 非 NULL 的行 = 3（id 2 和 5 被跳过）
--       COUNT(name)  只数 name 非 NULL 的行 = 4（id 4 被跳过）
-- ★ 所以「总人数」和「有成绩的人数」是两个不同的数，做报表时写错这个会被业务方骂。



-- 第2题｜先手工算再跑
--        SELECT AVG(score) FROM learn.nulltest;
--        我手工算的答案（把NULL当缺失，只算有值的）：
--        我手工算的答案（把NULL当0分）：
--        MySQL 实际返回：
--        MySQL 用的是哪种口径？如果我想用另一种，SQL 该怎么写？
-- 实际返回：80.0000
-- 手工算（NULL 当缺失，只算 80/90/70 三个）：(80+90+70)/3 = 80  ← MySQL 用这个口径
-- 手工算（NULL 当 0 分，算 5 个）：(80+0+90+70+0)/5 = 48
-- 想改成"NULL 当 0"的口径：
SELECT AVG(COALESCE(score, 0)) FROM learn.nulltest;   -- 返回 48
-- ★★ 这就是"口径"的力量：同一张表、同一个字段，两种理解差了近一倍。
--    工作中算任何平均值之前，必须先问："缺失值是当没这个人，还是当 0？"

-- 第3题｜【核心陷阱题】
--        SELECT * FROM learn.nulltest WHERE score <> 80;
--        返回几行？id=2 和 id=5（score 为 NULL 的那两行）在里面吗？
--        为什么？怎么改写才能把 score 为 NULL 的行也包含进来？
-- 返回 2 行：id=3(90) 和 id=4(70)
-- id=2 和 id=5 不在里面！因为 NULL <> 80 的结果是 UNKNOWN，而 WHERE 只保留 TRUE 的行
-- 改写：
SELECT * FROM learn.nulltest WHERE score <> 80 OR score IS NULL;   -- 返回 4 行
-- ★ 这是 SQL 里最容易静默出错的 bug：不报错、结果看起来合理、只是少了几行

-- 第4题｜用 COALESCE 把查询结果"补干净"
--        查出 id、name、score 三列，要求：name 为 NULL 的显示 '未知'，score 为 NULL 的显示 0
SELECT id, COALESCE(name, '未知') AS name, COALESCE(score, 0) AS score
FROM learn.nulltest;

-- 第5题｜防除零
--        SELECT SUM(score) / COUNT(*) FROM learn.nulltest WHERE id > 100;
--        这句会报错吗？返回什么？
--        改成用 NULLIF 保护，让它在没有数据时返回 NULL 而不是报错
-- 不报错，返回 NULL。
-- 因为没有任何行满足 id>100：COUNT(*) = 0，SUM(score) = NULL（全 NULL 时返回 NULL 而不是 0）
-- NULL / 0 的结果是 NULL，所以没报"除以零"的错。
-- 但如果换成这样就会报错：
--   SELECT 100 / COUNT(*) FROM learn.nulltest WHERE id > 100;   -- ❌ ERROR 1365 Division by 0
-- 用 NULLIF 保护：
SELECT 100 / NULLIF(COUNT(*), 0) AS result FROM learn.nulltest WHERE id > 100;
-- 返回 NULL，不报错。
-- ★ 工作里算「转化率 = 下单数 / 访问数」时，如果某天访问数是 0，不加保护整个报表任务就会挂掉。


-- ===== 做完之后 =====
-- 1) 错题记进 notes/99_我的错题本.md（只记错的）
-- 2) 写 1 条笔记进 notes/W1_*.md
-- 3) 提交：bash tools/daily-commit.sh 5 "NULL三值逻辑专题 + 5题"
