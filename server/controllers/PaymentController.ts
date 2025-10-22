import createHttpError from "http-errors";
import { PaymentService } from "../services/PaymentService";
import { RequestHandler } from "express";
import mongoose from "mongoose";

export class PaymentController {
  private _paymentService: PaymentService;
  constructor(ps: PaymentService) {
    this._paymentService = ps;
  }

  createPayment: RequestHandler<
    unknown,
    unknown,
    { uid: string; charity_id: string; amount: number }
  > = async (req, res, next) => {
    const { uid, charity_id, amount } = req.body;
    try {
      if (!uid || !charity_id || amount === undefined) {
        throw createHttpError(400, "All fields are required");
      }
      const newPayment = await this._paymentService.createPayment(
        new mongoose.Types.ObjectId(uid),
        new mongoose.Types.ObjectId(charity_id),
        amount
      );
      res.status(201).json({ message: "Payment Created", data: newPayment });
    } catch (error) {
      console.error(error);
      next(error);
    }
  };

  getPaymentsByUserId: RequestHandler<{ uid: string }, unknown, unknown> =
    async (req, res, next) => {
      const { uid } = req.params;
      try {
        if (!uid) {
          throw createHttpError(400, "User ID is required");
        }
        const payments = await this._paymentService.getPaymentsByUserId(
          new mongoose.Types.ObjectId(uid)
        );
        res.status(200).json({ data: payments });
      } catch (error) {
        console.error(error);
        next(error);
      }
    };

  getTotalAmountByCharityId: RequestHandler<
    { charity_id: string },
    unknown,
    unknown
  > = async (req, res, next) => {
    const { charity_id } = req.params;
    try {
      if (!charity_id) {
        throw createHttpError(400, "Charity ID is required");
      }
      const totalAmount = await this._paymentService.getTotalAmountByCharityId(
        new mongoose.Types.ObjectId(charity_id)
      );

      res.status(200).json({ data: { totalAmount } });
    } catch (error) {
      console.error(error);
      next(error);
    }
  };

  getTotalAmountByUserId: RequestHandler<{ uid: string }, unknown, unknown> =
    async (req, res, next) => {
      const { uid } = req.params;
      try {
        if (!uid) {
          throw createHttpError(400, "User ID is required");
        }
        const totalAmount = await this._paymentService.getTotalAmountByUserId(
          new mongoose.Types.ObjectId(uid)
        );

        res.status(200).json({ data: { totalAmount } });
      } catch (error) {
        console.error(error);
        next(error);
      }
    };
}
