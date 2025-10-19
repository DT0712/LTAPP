import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import connectDB from "./config/db.js";
import authRoutes from "./routes/auth.js";

dotenv.config();

// 👉 Khởi tạo Express trước khi dùng app
const app = express();

// 👉 Middleware
app.use(cors());
app.use(express.json());

// 👉 Kết nối MongoDB
connectDB();

// 👉 Test route gốc
app.get('/', (req, res) => {
  res.send('API đang chạy ngon lành 🚀');
});

// 👉 Các route thật
app.use("/api/auth", authRoutes);

// 👉 Chạy server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
