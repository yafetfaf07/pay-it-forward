import express, { Request, Response } from "express";
import dotenv from "dotenv";
import mongoose from "mongoose";
import morgan from "morgan";
import { UserService } from "./services/UserService";
import { UserController } from "./controllers/UserController";
import { UserRouter } from "./routes/UserRouter";
dotenv.config();
const app = express();
app.use(morgan('dev'));
app.use(express.json());

const userService = new UserService();
const userController = new UserController(userService);
const userRouter = new UserRouter(userController);
app.use("/api/users", userRouter.registerRoutes());


app.use("/", (req: Request, res: Response) => {
  res.status(200).json({ message: "Api worked" });
});

const PORT = process.env.PORT || 5000;
mongoose.connect(process.env.MONGO_DB_STRING!).then(() => {
  console.log("Connected to MongoDB");

  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}).catch(err => {
  console.error("Failed to connect to MongoDB", err);
});
