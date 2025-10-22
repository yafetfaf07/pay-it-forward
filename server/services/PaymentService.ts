import mongoose from "mongoose";
import Payment from "../models/Payment";

export class PaymentService {
    async createPayment(
        uid: mongoose.Types.ObjectId,
        charity_id: mongoose.Types.ObjectId,
        amount: number
    ) {
        return await Payment.create({ uid, charity_id, amount });
    }

    async getPaymentsByUserId(uid: mongoose.Types.ObjectId) {
        return await Payment.find({ uid }).exec();
    }
    async getTotalAmountByUserId(uid: mongoose.Types.ObjectId) {
        const result = await Payment.aggregate([
            { $match: { uid } },
            { $group: { _id: null, totalAmount: { $sum: "$amount" } } }
        ]).exec();

        return result.length > 0 ? result[0].totalAmount : 0;
    }

    async getTotalAmountByCharityId(charity_id: mongoose.Types.ObjectId) {
        const result = await Payment.aggregate([
            { $match: { charity_id } },
            { $group: { _id: null, totalAmount: { $sum: "$amount" } } }
        ]).exec();

        return result.length > 0 ? result[0].totalAmount : 0;
    }
}