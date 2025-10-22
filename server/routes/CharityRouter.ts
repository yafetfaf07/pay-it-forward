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
        this.router.get('/getAll', this._charityController.getAll);
        return this.router;
    }
}