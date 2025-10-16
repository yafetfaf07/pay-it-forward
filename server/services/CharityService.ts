import Charity from "../models/Charity";
export class CharityService {
    async createCharity(name:string, phone_no:string) {
        return await Charity.create({ name, phone_no });
    }
    async loginCharity(phone_no:string) {
        return await Charity.findOne({ phone_no }).exec();
    }
    async getAllCharities() {
        return await Charity.find().exec();
    }
  
}