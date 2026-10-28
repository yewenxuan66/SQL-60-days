-- =====================================================================
--  D4｜ORDER BY 排序 + LIMIT 分页
--  2026-10-22（周四）｜第 1 周｜40 天计划的第 4 天｜5题
--  讲义：第1周_D1-D5_基础查询与NULL.md  →  搜「D4」跳到那一节
-- ---------------------------------------------------------------------
--  45 分钟怎么用：
--    ① 读讲义「二、讲解」                                       20 分钟
--    ② 在下面每题的「你的答案」处写 SQL，选中按 Ctrl+Enter 执行    20 分钟
--    ③ 写完再看讲义里的答案区；错题必须关掉答案重写一遍
--    ④ 写 1 条笔记进 notes/，然后提交：                          5 分钟
--       bash tools/daily-commit.sh 4 "ORDER BY与LIMIT分页 + 5题"
--  ⚠️ 本文件不含答案。答案在讲义里，做完再看。
-- =====================================================================

USE employees;   -- 多数题用 employees 库；题目里写了 learn.xxx 的用 learn 库
                 -- 首次做题前先跑一次：datasets/setup_learn_tables.sql

-- 第1题｜按入职日期从晚到早，列出前 10 名员工的编号、姓名、入职日期
SELECT emp_no,employees.first_name,employees.last_name,employees.hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 10;

-- 第2题｜查出月薪最高的 5 条薪资记录（员工编号、月薪、生效日期）
SELECT emp_no,salaries.salary,salaries.from_date
FROM salaries
ORDER BY salary DESC
LIMIT 5;

-- 第3题｜按性别升序、同性别内按入职日期降序，列出编号/性别/入职日期，只看前 20 行
SELECT emp_no,employees.gender,employees.hire_date
FROM employees
ORDER BY gender ASC ,hire_date DESC
LIMIT 20;

-- 第4题｜员工表分页：每页 20 条，取第 3 页。用两种写法各写一遍（LIMIT a,b 和 LIMIT b OFFSET a）
--        并加上能保证顺序稳定的排序字段
SELECT *
FROM employees
ORDER BY emp_no
LIMIT 40,20;
-- LIMIT 20 OFFSET 40;

-- 第5题｜【概念题，不用写SQL】下面这句连续执行两次，结果一定相同吗？为什么？
        SELECT * FROM employees LIMIT 5;
--        我的回答：嗯？是因为pycharm的原因吗，他给我的结果都是相同的。。。
-- 标准答案：-- 不一定相同。MySQL 不保证行的自然顺序，返回顺序受存储引擎读取方式、
-- 是否走索引、并发写入等影响。分页时必须加 ORDER BY，且排序字段要能唯一确定顺序
-- （通常带上主键），否则会出现跨页重复或遗漏。
-- ===== 做完之后 =====
-- 1) 错题记进 notes/99_我的错题本.md（只记错的）
-- 2) 写 1 条笔记进 notes/W1_*.md
-- 3) 提交：bash tools/daily-commit.sh 4 "ORDER BY与LIMIT分页 + 5题"
