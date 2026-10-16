-- =====================================================================
--  D38｜EXPLAIN 怎么读 + 索引失效 3 种（只到这个深度）
--  2026-12-09（周三）｜第 8 周｜40 天计划的第 38 天｜5题
--  讲义：第8周_D36-D40_项目与模拟笔试.md  →  搜「D38」跳到那一节
-- ---------------------------------------------------------------------
--  45 分钟怎么用：
--    ① 读讲义「二、讲解」                                       20 分钟
--    ② 在下面每题的「你的答案」处写 SQL，选中按 Ctrl+Enter 执行    20 分钟
--    ③ 写完再看讲义里的答案区；错题必须关掉答案重写一遍
--    ④ 写 1 条笔记进 notes/，然后提交：                          5 分钟
--       bash tools/daily-commit.sh 38 "EXPLAIN与索引失效3种 + 5题"
--  ⚠️ 本文件不含答案。答案在讲义里，做完再看。
-- =====================================================================

USE employees;   -- 多数题用 employees 库；题目里写了 learn.xxx 的用 learn 库
                 -- 首次做题前先跑一次：datasets/setup_learn_tables.sql

-- 第1题｜给 employees.hire_date 建索引：CREATE INDEX idx_hire ON employees(hire_date);
--        然后分别 EXPLAIN 这两句，把 type / key / rows / Extra 四列抄进注释
--        A: SELECT * FROM employees WHERE YEAR(hire_date) = 1995;
--        B: SELECT * FROM employees WHERE hire_date >= '1995-01-01' AND hire_date < '1996-01-01';
--        哪个走索引？


-- 第2题｜给 salaries.emp_no 建索引（如果还没有），EXPLAIN 对比：
--        A: SELECT * FROM salaries WHERE emp_no = 10050;
--        B: SELECT * FROM salaries WHERE emp_no = '10050';
--        两次有区别吗？为什么？（提示：INT 列和字符串比 vs INT 列和数字比）


-- 第3题｜给 employees.last_name 建索引，EXPLAIN 对比：
--        A: LIKE 'Wang%'   B: LIKE '%Wang%'
--        记录两次的 type 和 key


-- 第4题｜EXPLAIN 一句深分页查询，看 rows 有多大：
--        SELECT * FROM salaries ORDER BY emp_no LIMIT 100000, 10;
--        然后改写成"游标式"，再 EXPLAIN 对比


-- 第5题｜【背诵】不看讲义，写出面试标准回答模板（第4节那段）

-- ===== 做完之后 =====
-- 1) 错题记进 notes/99_我的错题本.md（只记错的）
-- 2) 写 1 条笔记进 notes/W8_*.md
-- 3) 提交：bash tools/daily-commit.sh 38 "EXPLAIN与索引失效3种 + 5题"
