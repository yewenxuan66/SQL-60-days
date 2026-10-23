-- =====================================================================
--  D3｜IN / BETWEEN / LIKE：三种更省事的写法
--  2026-10-21（周三）｜第 1 周｜40 天计划的第 3 天｜5题
--  讲义：第1周_D1-D5_基础查询与NULL.md  →  搜「D3」跳到那一节
-- ---------------------------------------------------------------------
--  45 分钟怎么用：
--    ① 读讲义「二、讲解」                                       20 分钟
--    ② 在下面每题的「你的答案」处写 SQL，选中按 Ctrl+Enter 执行    20 分钟
--    ③ 写完再看讲义里的答案区；错题必须关掉答案重写一遍
--    ④ 写 1 条笔记进 notes/，然后提交：                          5 分钟
--       bash tools/daily-commit.sh 3 "IN/BETWEEN/LIKE + 5题"
--  ⚠️ 本文件不含答案。答案在讲义里，做完再看。
-- =====================================================================

USE employees;   -- 多数题用 employees 库；题目里写了 learn.xxx 的用 learn 库
                 -- 首次做题前先跑一次：datasets/setup_learn_tables.sql

-- 第1题｜用 IN 查出部门 d001、d003、d005 的所有任职记录
SELECT *
FROM employees.dept_emp
WHERE dept_id IN ('d001','d003','d005');

-- 第2题｜用 BETWEEN 查出月薪在 6000 到 10000 之间（含两端）的薪资记录
--        然后用 >= 和 <= 再写一遍，两次跑出来的行数应该完全一样
SELECT *
FROM employees.salaries
WHERE salary BETWEEN 6000 AND 10000;

-- SELECT *
-- FROM salaries
-- WHERE salary >=6000 AND salary <=10000;
-- 第3题｜查出姓 Wang 或姓 Zhang 的员工（编号、姓、名）
SELECT emp_no,employees.last_name,employees.first_name
FROM employees.employees
WHERE last_name LIKE 'Wang%' OR last_name LIKE 'Zhang%';

-- 第4题｜查出姓恰好是 3 个字符的员工（提示：LIKE '___'）
SELECT emp_no,last_name
FROM employees.employees
WHERE last_name LIKE '___';

-- 第5题｜查出职位名里含 "Engineer" 的所有职位记录（表名 titles）
--        追问：这个查询会用上索引吗？为什么？
SELECT *
FROM employees.titles
WHERE title LIKE '%Engineer%';

-- 追问答案：不会用上索引。因为 LIKE 以 % 开头（前导通配符），
--           MySQL 无法用 B+ 树的有序性做定位，只能全表扫描。
--           改成 LIKE 'Engineer%' 就能用上索引（但语义变成"以 Engineer 开头"）。
-- ===== 做完之后 =====
-- 1) 错题记进 notes/99_我的错题本.md（只记错的）
-- 2) 写 1 条笔记进 notes/W1_*.md
-- 3) 提交：bash tools/daily-commit.sh 3 "IN/BETWEEN/LIKE + 5题"
