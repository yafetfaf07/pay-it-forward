import {model,Schema, Types} from "mongoose";

const paymentSchema = new Schema({
    uid:{type:Types.ObjectId, required:true, ref:'User'},
    merchant_id:{type:Types.ObjectId, required:true, ref:'Merchant'},
    charity_id:{type:Types.ObjectId, required:true, ref:'Charity'},
    amount:{type:Number, required:true},
    donationAmount:{type:Number, required:true},
    date:{type:Date, default:Date.now}
});

const Payment = model('Payment', paymentSchema);
export default Payment;