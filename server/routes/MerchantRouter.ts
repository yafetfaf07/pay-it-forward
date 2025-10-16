import { MerchantController } from "../controllers/MerhcantController";
import express from "express";

export class MerchantRouter {
    private _merchantController: MerchantController;
    router;
    constructor(mc: MerchantController) {
        this._merchantController = mc;
        this.router = express.Router();
    }
    registerRoutes() {
        this.router.post("/create", this._merchantController.createMerchant);
        this.router.post('/login', this._merchantController.login)
        return this.router;
    }
}