-- =====================================================================
-- setup_learn_tables.sql  ·  一次性建好 40 天计划里所有练习用小表
-- 用法（跑一次就够，重复跑也安全，因为都是 DROP + CREATE）：
--   方式1（PyCharm）：打开本文件 → 右上角选中数据源和 schema → Ctrl+Enter 全部执行
--   方式2（命令行）：mysql -u root -p
--                    mysql> SOURCE C:/Users/yewenxuan/Desktop/sql-60-days/datasets/setup_learn_tables.sql;
--
-- 建好的表（都在 learn 库里）：
--   nulltest  D5  NULL 三值逻辑专题
--   t_null / t_main  D14、D18  NOT IN 的 NULL 陷阱
--   weather   D15 自连接（温度比昨天高）
--   ranktest  D22 三种排名函数对比
--   logins    D29 连续登录 N 天
--   visits    D31 留存率
--   events    D32 转化漏斗
--   dirty     D34 字符串函数解析脏数据
--   scores    D35 行转列 / 列转行
-- =====================================================================

CREATE DATABASE IF NOT EXISTS learn DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE learn;

-- ---------- D5：NULL 三值逻辑 ----------
DROP TABLE IF EXISTS nulltest;
CREATE TABLE nulltest (id INT, name VARCHAR(20), score INT);
INSERT INTO nulltest VALUES (1,'A',80),(2,'B',NULL),(3,'C',90),(4,NULL,70),(5,'E',NULL);

-- ---------- D14 / D18：NOT IN 的 NULL 陷阱 ----------
DROP TABLE IF EXISTS t_null;
DROP TABLE IF EXISTS t_main;
CREATE TABLE t_null (id INT);
CREATE TABLE t_main (id INT);
INSERT INTO t_null VALUES (1),(2),(NULL);
INSERT INTO t_main VALUES (1),(3),(5);

-- ---------- D15：自连接（温度比昨天高）----------
DROP TABLE IF EXISTS weather;
CREATE TABLE weather (id INT, recordDate DATE, temperature INT);
INSERT INTO weather VALUES
 (1,'2026-10-01',20),(2,'2026-10-02',25),(3,'2026-10-03',22),
 (4,'2026-10-05',30),(5,'2026-10-06',28);
-- ★ 注意 10-04 故意缺一天，用来演示"按 id 连接"和"按日期连接"的差异

-- ---------- D22：三种排名函数对比 ----------
DROP TABLE IF EXISTS ranktest;
CREATE TABLE ranktest (name VARCHAR(10), score INT);
INSERT INTO ranktest VALUES ('A',100),('B',90),('C',90),('D',80),('E',70);
-- ★ B 和 C 并列 90 分，用来看 ROW_NUMBER / RANK / DENSE_RANK 的差异

-- ---------- D29：连续登录 N 天 ----------
DROP TABLE IF EXISTS logins;
CREATE TABLE logins (user_id INT, login_date DATE);
INSERT INTO logins VALUES
 (1,'2026-10-01'),(1,'2026-10-02'),(1,'2026-10-03'),(1,'2026-10-05'),(1,'2026-10-06'),
 (1,'2026-10-01'),
 (2,'2026-10-01'),(2,'2026-10-02'),(2,'2026-10-03'),(2,'2026-10-04'),
 (3,'2026-10-08'),
 (4,'2026-10-01'),(4,'2026-10-03'),(4,'2026-10-05'),(4,'2026-10-07');
-- ★ user1 的 10-01 故意重复插入一次 → 用来演示"为什么必须先 DISTINCT"
-- ★ user4 每隔一天登录一次 → 用来做"允许断1天"的挑战题
-- 预期答案：连续≥3天 → user1(10-01~10-03, 3天)、user2(10-01~10-04, 4天)
--           最长连续 → user2=4, user1=3, user3=1, user4=1

-- ---------- D31：留存率 ----------
DROP TABLE IF EXISTS visits;
CREATE TABLE visits (user_id INT, visit_date DATE, is_new TINYINT);
INSERT INTO visits VALUES
 (1,'2026-10-01',1),(1,'2026-10-02',0),(1,'2026-10-03',0),
 (2,'2026-10-01',1),(2,'2026-10-03',0),
 (3,'2026-10-01',1),
 (4,'2026-10-02',1),(4,'2026-10-03',0),(4,'2026-10-04',0),
 (5,'2026-10-02',1);
-- 预期答案：10-01 新增 3 人(user1,2,3)，次日只有 user1 回来 → 次日留存率 33.33%
--           10-02 新增 2 人(user4,5)，次日只有 user4 回来 → 次日留存率 50.00%

-- ---------- D32：转化漏斗 ----------
DROP TABLE IF EXISTS events;
CREATE TABLE events (user_id INT, event VARCHAR(20), event_time DATETIME);
INSERT INTO events VALUES
 (1,'view','2026-10-01 10:00:00'),(1,'click','2026-10-01 10:05:00'),
 (1,'cart','2026-10-01 10:10:00'),(1,'pay','2026-10-01 10:20:00'),
 (2,'view','2026-10-01 11:00:00'),(2,'click','2026-10-01 11:05:00'),
 (2,'cart','2026-10-01 11:10:00'),
 (3,'view','2026-10-01 12:00:00'),(3,'click','2026-10-01 12:30:00'),
 (4,'view','2026-10-01 13:00:00'),
 (5,'view','2026-10-01 14:00:00'),(5,'click','2026-10-01 14:10:00'),
 (5,'pay','2026-10-01 14:20:00');
-- ★ user5 跳过了 cart 直接 pay → 用来演示"宽松漏斗"和"严格漏斗"的差异
-- 预期：宽松版 曝光5/点击4/加购2/支付2；严格版 曝光5/点击4/加购2/支付1

-- ---------- D34：字符串函数解析脏数据 ----------
DROP TABLE IF EXISTS dirty;
CREATE TABLE dirty (id INT, raw_text VARCHAR(200));
INSERT INTO dirty VALUES
 (1,'姓名:张三,手机:13800138000,城市:湖南长沙'),
 (2,'姓名:李四,手机:138-0013-8001,城市:广东深圳'),
 (3,'姓名:王五,手机:,城市:北京'),
 (4,'姓名:,手机:13900139000,城市:上海浦东新区');

-- ---------- D35：行转列 / 列转行 ----------
DROP TABLE IF EXISTS scores;
CREATE TABLE scores (student VARCHAR(10), subject VARCHAR(10), score INT);
INSERT INTO scores VALUES
 ('张三','语文',80),('张三','数学',90),('张三','英语',85),
 ('李四','语文',70),('李四','数学',95),
 ('王五','英语',60),('王五','语文',NULL);
-- ★ 王五只有英语有分、语文是 NULL、数学缺考 → 用来演示"平均分口径"问题

-- =====================================================================
-- 建完之后的验证（应该看到 11 张表）
-- =====================================================================
SELECT table_name AS 表名, table_rows AS 约行数
FROM information_schema.tables
WHERE table_schema = 'learn'
ORDER BY table_name;

SELECT '① nulltest' AS 表, COUNT(*) AS 行数 FROM nulltest
UNION ALL SELECT '② t_null', COUNT(*) FROM t_null
UNION ALL SELECT '③ t_main', COUNT(*) FROM t_main
UNION ALL SELECT '④ weather', COUNT(*) FROM weather
UNION ALL SELECT '⑤ ranktest', COUNT(*) FROM ranktest
UNION ALL SELECT '⑥ logins', COUNT(*) FROM logins
UNION ALL SELECT '⑦ visits', COUNT(*) FROM visits
UNION ALL SELECT '⑧ events', COUNT(*) FROM events
UNION ALL SELECT '⑨ dirty', COUNT(*) FROM dirty
UNION ALL SELECT '⑩ scores', COUNT(*) FROM scores;
-- 预期行数：5 / 3 / 3 / 5 / 5 / 15 / 10 / 13 / 4 / 7