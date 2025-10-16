import Merchant from "../models/Merchant";
export class MerchantService {  
    async createMerchant(name:string, phone_no:string) {  
return await Merchant.create({name,phone_no});
     }
     async loginMerchant(phone_no:string) {
        return await Merchant.findOne({ phone_no }).exec();
    }
    async getAllMerchants() {
        return await Merchant.find().exec();
    }

}