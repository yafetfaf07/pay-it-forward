import User from "../models/User";
export class UserService {
    async createUser(
        name: string,
        phone_no: string,
        
    ) {
        return await User.create({ name, phone_no });
    }
    async loginUser(phone_no:string) {
        return await User.findOne({ phone_no }).exec();
    }
    async getUserByPhoneNumber(phone_no: string, ) {
        return await User.findOne({ phone_no: phone_no,  }).exec();
    }
    
}