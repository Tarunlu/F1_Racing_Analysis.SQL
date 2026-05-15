# F1_Racing_Analysis.SQL
🏎️ F1 Racing Data Analysis using PostgreSQL — Explores drivers, constructors, circuits, race results, and championships through 20 analytical SQL queries.

## 🏁 Project Overview

This project dives deep into the world of **Formula 1 Racing** using **PostgreSQL**.  
Through **20 powerful SQL queries**, we analyze decades of F1 data — from championship battles to circuit records, from sprint race winners to drivers who never made it to the podium.

---

## 🗄️ Database Tables Used

| Table | Description |
|---|---|
| `drivers` | All F1 drivers info |
| `constructors` | F1 team/constructor details |
| `races` | Race calendar data |
| `circuits` | Circuit info with location & country |
| `results` | Race results per driver per race |
| `driver_standings` | Points standings per driver |
| `constructor_standings` | Points standings per constructor |
| `constructor_results` | Constructor race results |
| `qualifying` | Qualifying session data |
| `lap_times` | Individual lap time records |
| `pit_stops` | Pit stop data per race |
| `sprint_results` | Sprint race results |
| `status` | Race finish status (DNF, DNS, etc.) |
| `seasons` | Season year records |

---

## 🔍 Queries at a Glance

| # | Question |
|---|---|
| 01 | 🌍 Which country has produced the most F1 drivers? |
| 02 | 🏟️ Which country has the most F1 circuits? |
| 03 | 🏗️ Countries with exactly 5 constructors |
| 04 | 📅 Number of races per year |
| 05 | 👶👴 Who is the youngest and oldest F1 driver? |
| 06 | 🥇🏁 First and last race of each season |
| 07 | 🏎️ Circuit that has hosted the most races |
| 09 | 🏆 All F1 World Champions and how many times they won |
| 10 | 🔧 Constructor with most championship titles |
| 11 | 🥇🥈 Championship Winner & Runner-up per season (2020+) |
| 12 | 🌟 Top 10 drivers with the most race wins |
| 13 | 🏅 Top 3 constructors of all time |
| 14 | 🔄 Drivers who won races with multiple teams |
| 15 | ❌ Drivers who never won a single race |
| 16 | 😔 Constructors who never scored a point |
| 17 | 💪 Drivers with more than 50 race wins |
| 18 | 💰 Points structure for the 2022 season |
| 19 | ⚡ Winners of every Sprint race in F1 |
| 20 | 🚫 Driver with most "Did Not Qualify" records |

---

## 💡 Key SQL Concepts Used

```sql
✅ Aggregate Functions      → COUNT(), SUM(), AVG(), MIN(), MAX()
✅ Window Functions         → RANK(), FIRST_VALUE(), LAST_VALUE(), COUNT() OVER()
✅ Common Table Expressions → WITH cte AS (...)
✅ Joins                    → INNER JOIN, multiple table joins
✅ Subqueries               → Nested SELECT statements
✅ HAVING Clause            → Filter after GROUP BY
✅ String Functions          → CONCAT(), STRING_AGG(), LOWER()
✅ CASE Statements          → Conditional logic in SELECT
✅ DISTINCT                 → Remove duplicates
```

---

## 📊 Sample Insights You'll Discover

- 🇬🇧 **UK** has produced the most F1 drivers
- 🏆 **Lewis Hamilton** and **Michael Schumacher** dominate championship wins
- 🔧 **Ferrari** & **Mercedes** lead constructor championships
- 🏟️ **Monza (Italy)** is one of the most frequently used circuits
- ⚡ Sprint races are a relatively new and exciting addition to F1!

---
## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **PostgreSQL** | Database engine |
| **pgAdmin 4** | GUI for running queries |
| **SQL** | Query language |
| **GitHub** | Version control & sharing |

---
