import {model,Schema} from "mongoose";

const merchantSchema = new Schema({
    name: {type: String, required: true},
    phone_no: {type: String, required: true, unique: true},
});

const Merchant = model('Merchant', merchantSchema);
export default Merchant;