import express from "express";

const app = express();
app.use(express.json());
app.use("/", (req, res) => {
  res.status(200).json({ message: "Api worked" });
});
app.listen(5000, () => {
  console.log("Server running on port 5000");
});
