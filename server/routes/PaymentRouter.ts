import { PaymentController } from "../controllers/PaymentController";
import express from "express";

export class PaymentRouter {
  private _paymentController: PaymentController;
  router;
  constructor(pc: PaymentController) {
    this._paymentController = pc;
    this.router = express.Router();
  }
  registerRoutes() {
    this.router.post(
      "/createPayment",
      this._paymentController.createPayment
    );
    this.router.get(
      "/getPaymentsByUserId/:uid",
      this._paymentController.getPaymentsByUserId
    );
    this.router.get(
      "/getTotalAmountByCharityId/:charity_id",
      this._paymentController.getTotalAmountByCharityId
    );
    this.router.get(
        "/getTotalAmountByUserId/:uid",
        this._paymentController.getTotalAmountByUserId
      );
    return this.router;
  }
}