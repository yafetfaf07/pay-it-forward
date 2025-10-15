import {model,Schema} from "mongoose";

const merchantSchema = new Schema({
    name: {type: String, required: true},
    password: {type: String, required: true, select:false},
    phone_no: {type: String, required: true, unique: true},
});

const Merchant = model('Merchant', merchantSchema);
export default Merchant;