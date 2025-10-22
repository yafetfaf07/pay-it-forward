import mongoose from "mongoose";
import Payment from "../models/Payment";
import Charity from "../models/Charity";

export class PaymentService {
    async createPayment(
        uid: mongoose.Types.ObjectId,
        charity_id: mongoose.Types.ObjectId,
        amount: number
    ) {
        return await Payment.create({ uid, charity_id, amount });
    }

    async getPaymentsByUserId(uid: mongoose.Types.ObjectId) {
        return await Payment.aggregate([
            { $match: { uid } },
            {
                $lookup: {
                    from: "charities",
                    localField: "charity_id",
                    foreignField: "_id",
                    as: "charity"
                }
            },
            { $unwind: "$charity" },
            {
                $project: {
                    charity_name: "$charity.name",
                    amount: "$amount",
                    date_created: {
                        $concat: [
                            {
                                $dateToString: {
                                    format: "%b %d %Y %H:%M",
                                    date: "$date" // Updated to use 'date' field
                                }
                            },
                            " ",
                            {
                                $cond: {
                                    if: { $gte: [{ $hour: "$date" }, 12] }, // Updated to use 'date' field
                                    then: "P.M",
                                    else: "A.M"
                                }
                            }
                        ]
                    }
                }
            }
        ]).exec();
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