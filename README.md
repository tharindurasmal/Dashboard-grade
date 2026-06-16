# 📊 Dashboard Grade

> A modern full-stack dashboard system powered by **Next.js + Node.js + Neon PostgreSQL**, built for fast, scalable, and clean data visualization.

---

## 🚀 Tech Stack

![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge\&logo=next.js\&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge\&logo=node.js\&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge\&logo=postgresql\&logoColor=white)
![Neon](https://img.shields.io/badge/Neon-00E699?style=for-the-badge\&logoColor=black)

---

## 📸 Preview

> Add screenshots here (recommended for top-tier GitHub repos)

```
![Dashboard](assets/dashboard.png)

```

---

## 📁 Project Structure

```bash id="p0x1a9"
Dashboard-grade/
│
├── dashboard/        # Main frontend app
├── public/           # Static assets
├── src/              # Source code
├── .env              # Environment variables
├── .gitignore
└── README.md
```

---

## ⚙️ Installation & Setup

### 1️⃣ Clone Repository

```bash id="g7xq2l"
git clone https://github.com/tharindurasmal/Dashboard-grade.git
open terminal
cd Dashboard-grade
cd dashboard
code .
```

---

### 2️⃣ Install Dependencies

```bash id="b2k9pl"
npm install
```

---

### 3️⃣ Environment Setup ## | (Database Setup (Neon PostgreSQL))

Create a `.env` file:  

```bash id="z9xq11"
DATABASE_URL=your_neon_connection_string
```

---

## 🗄️ Database Setup (Neon PostgreSQL)

### 1️⃣ Create Account

👉 https://neon.tech

* Sign up / Login
* Create a new project

---

### 2️⃣ Get Connection String and paste it in .env

From Neon dashboard:

```bash id="n8c1pq"
DATABASE_URL=postgresql://username:password@host/database?sslmode=require
```

---

### 3️⃣ Run SQL Schema (schema.sql)

Open **Neon SQL Editor** and run:

```sql id="m4xq81"
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## ▶️ Run Project

```bash id="k9q2lp"
npm run dev
```

Then open:

```
http://localhost:3000
```
