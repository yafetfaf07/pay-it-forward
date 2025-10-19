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
        this.router.post('/login', this._userController.login)
        this.router.get("/getUsername/:id", this._userController.findUserById);
        return this.router;
    }
}