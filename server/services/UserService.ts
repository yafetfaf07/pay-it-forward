import User from "../models/User";
export class UserService {
    async createUser(
        fname: string,
        lname: string,
        phone_no: string,
        password: string
    ) {
        return await User.create({ fname, lname, phone_no, password });
    }
    async loginUser(phone_no: string, password: string) {
        return await User.findOne({ phone_no, password:password }).exec();
    }
    async getUserByPhoneNumber(phone_no: string, ) {
        return await User.findOne({ phone_no: phone_no,  }).exec();
    }
    
}