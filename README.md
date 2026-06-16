## 🗄️ Database Setup (Neon PostgreSQL)

Follow these steps to connect the project to a Neon database and run the schema.

---

### 1️⃣ Create Neon Account

Go to:
👉 https://neon.tech

* Sign up / Log in
* Click **"Create Project"**
* Choose a project name and region

---

### 2️⃣ Get Connection String

After creating the project:

* Go to **Dashboard → Connection Details**
* Copy the **connection string**

Example:

```bash
postgresql://username:password@host/database?sslmode=require
```

---

### 3️⃣ Configure `.env`

Create a `.env` file in the root folder and add:

```bash
DATABASE_URL=your_connection_string_here
```

---

### 4️⃣ Run SQL Schema

* Open your Neon project
* Go to **SQL Editor**
* Copy and paste your schema file (e.g., `schema.sql`)

Example:

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

* Click **Run** to execute

---

### ✅ Done!

Your database is now ready and connected to the project.
