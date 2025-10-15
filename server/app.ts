import express, { Request, Response } from "express";
import dotenv from "dotenv";
import mongoose from "mongoose";
import morgan from "morgan";
import * as envalid from "envalid"; // Already in your deps
import { UserService } from "./services/UserService";
import { UserController } from "./controllers/UserController";
import { UserRouter } from "./routes/UserRouter";

// Load .env file (local dev) or Render env vars (production)
dotenv.config();

// Define & validate environment variables
const env = envalid.cleanEnv(process.env, {
  MONGO_DB_STRING: envalid.str({
    desc: "MongoDB connection string",
    default: process.env.NODE_ENV === "development" 
      ? process.env.MONGO_DB_LOCAL!  // Production must provide
      : process.env.MONGO_DB_STRING!// Local dev default
  }),
  NODE_ENV: envalid.str({ 
    desc: "Environment (development/production)", 
    default: "development" 
  })
});

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

// Connect to MongoDB with environment-specific string
mongoose.connect(env.MONGO_DB_STRING)
  .then(() => {
    console.log(`✅ Connected to MongoDB (${env.NODE_ENV})`);
    
    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT} (${env.NODE_ENV})`);
    });
  })
  .catch(err => {
    console.error("❌ Failed to connect to MongoDB", err);
  });