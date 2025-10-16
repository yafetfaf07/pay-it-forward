import {model, Schema,Types} from "mongoose";

const userSchema = new Schema({
    name: {type: String, required: true},
    password: {type: String, required: true},

});

const User = model('User', userSchema);
export default User;