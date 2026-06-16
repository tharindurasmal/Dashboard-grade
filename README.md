# 📊 Dashboard Grade

> A modern full-stack dashboard system powered by **Next.js + Node.js + Neon PostgreSQL**, built for fast, scalable, and clean data visualization.

---

## 🚀 Tech Stack

![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge\&logo=next.js\&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge\&logo=node.js\&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge\&logo=postgresql\&logoColor=white)
![Neon](https://img.shields.io/badge/Neon-00E699?style=for-the-badge\&logoColor=black)

---

## ✨ Features

* 📊 Interactive analytics dashboard
* ⚡ Fast and responsive UI
* 🗄️ Neon PostgreSQL database integration
* 🔐 Environment-based configuration (.env)
* 🧩 Modular and scalable architecture
* 📈 Real-time data handling (if enabled)

---

## 📸 Preview

> Add screenshots here (recommended for top-tier GitHub repos)

```
/screenshots/dashboard.png
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
cd Dashboard-grade
cd dashboard
```

---

### 2️⃣ Install Dependencies

```bash id="b2k9pl"
npm install
```

---

### 3️⃣ Environment Setup

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

### 2️⃣ Get Connection String

From Neon dashboard:

```bash id="n8c1pq"
postgresql://username:password@host/database?sslmode=require
```

---

### 3️⃣ Run SQL Schema

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

---

## 🧠 How It Works

* Frontend renders dashboard UI
* Backend connects via `DATABASE_URL`
* Neon PostgreSQL stores all data
* UI dynamically updates from database

---

## 🔒 Security Best Practices

* `.env` file is ignored in Git
* No sensitive credentials exposed
* Secure cloud PostgreSQL connection (Neon)

---

## 🚀 Deployment

Recommended platforms:

* Vercel (Frontend)
* Render / Railway (Backend)

---

## 📌 Roadmap

* [ ] Authentication system
* [ ] Role-based access control
* [ ] Advanced analytics charts
* [ ] API optimization
* [ ] Deployment automation

---

## 👨‍💻 Author

**Tharindu Rasmal**

* GitHub: https://github.com/tharindurasmal
* Email: [tharindurasmal1@gmail.com](mailto:tharindurasmal1@gmail.com)

---

## ⭐ Support

If you like this project, don’t forget to ⭐ the repo!
