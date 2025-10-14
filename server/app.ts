import express, { Request, Response } from "express";

const app = express();
app.use(express.json());
app.use("/", (req:Request, res:Response) => {
  res.status(200).json({ message: "Api worked" });
});
app.listen(5000, () => {
  console.log("Server running on port 5000");
});
