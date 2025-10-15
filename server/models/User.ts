import {model, Schema,Types} from "mongoose";

const userSchema = new Schema({
    fname: {type: String, required: true},
    lname: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    phone_no: {type: String, required: true, unique: true},

});

const User = model('User', userSchema);
export default User;