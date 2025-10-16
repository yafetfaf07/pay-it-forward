import { CharityController } from "../controllers/CharityController";
import express from "express";
export class CharityRouter {
    private _charityController: CharityController;
    router;
    constructor(cc: CharityController) {
        this._charityController = cc;
        this.router = express.Router();
    }
    registerRoutes() {
        this.router.post("/create", this._charityController.createCharity);
        this.router.post('/login', this._charityController.login)
        return this.router;
    }
}