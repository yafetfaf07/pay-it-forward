import { UserController } from "../controllers/UserController";
import express from "express";

export class UserRouter { 
    private _userController: UserController;
    router;
    constructor(uc: UserController) {
        this._userController = uc;
        this.router = express.Router();
    }
    registerRoutes() {
        this.router.post("/register", this._userController.createUser);
        return this.router;
    }
}