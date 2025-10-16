import express, { NextFunction, Request, Response } from "express";
import dotenv from "dotenv";
import mongoose from "mongoose";
import morgan from "morgan";
import * as envalid from "envalid"; // Already in your deps
import { UserService } from "./services/UserService";
import { UserController } from "./controllers/UserController";
import { UserRouter } from "./routes/UserRouter";
import path from "path";
import { isHttpError } from "http-errors";
import { PostService } from "./services/PostService";
import { PostController } from "./controllers/PostController";
import { PostRouter } from "./routes/PostRouter";
import { CharityService } from "./services/CharityService";
import { CharityController } from "./controllers/CharityController";
import { CharityRouter } from "./routes/CharityRouter";
import { MerchantService } from "./services/MerchantService";
import { MerchantController } from "./controllers/MerhcantController";
import { MerchantRouter } from "./routes/MerchantRouter";
dotenv.config();

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
app.use(express.urlencoded({ extended: true }));
app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));

// Users
const userService = new UserService();
const userController = new UserController(userService);
const userRouter = new UserRouter(userController);

// Posts
const postService = new PostService();
const postController = new PostController(postService);
const postRouter = new PostRouter(postController);

// Charities
const charityService = new CharityService();
const charityController = new CharityController(charityService);
const charityRouter = new CharityRouter(charityController);

//Merchants
const merchantService = new MerchantService();
const merchantController = new MerchantController(merchantService);
const merchantRouter = new MerchantRouter(merchantController);

// Mount routers
app.use("/api/merchants", merchantRouter.registerRoutes());
app.use("/api/users", userRouter.registerRoutes());
app.use("/api/posts", postRouter.registerRoutes());
app.use("/api/charities", charityRouter.registerRoutes());


app.use((error: unknown, req: Request, res: Response, next: NextFunction) => {
  let errorMessage = 'An unknown error occured';
  console.error(error);
  let stausCode=500;
    if(isHttpError(error)) {
      stausCode=error.status;
      errorMessage=error.message
    }
  res.status(stausCode).json({
    error: errorMessage,
  });
});

const PORT = process.env.PORT || 5000;

mongoose.connect(env.MONGO_DB_STRING)
  .then(() => {
    console.log(`Connected to MongoDB (${env.NODE_ENV})`);
    
    app.listen(PORT, () => {
      console.log(` Server running on port ${PORT} (${env.NODE_ENV})`);
    });
  })
  .catch(err => {
    console.error(" Failed to connect to MongoDB", err);
  });