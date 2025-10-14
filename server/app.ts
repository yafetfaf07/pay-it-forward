import express, { Request, Response } from "express";

const app = express();
app.use(express.json());

// Example route (expand with your actual routes, e.g., for Mongoose/MongoDB)
app.use("/", (req: Request, res: Response) => {
  res.status(200).json({ message: "Api worked" });
});

const PORT = process.env.PORT || 5000;  // Use Render's PORT or fallback to 5000
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});