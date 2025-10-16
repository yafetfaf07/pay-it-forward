import {model,Schema} from "mongoose";

const charitySchema = new Schema({
    name: {type: String, required: true},
    phone_no: {type: String, required: true, unique: true},
});

const Charity = model('Charity', charitySchema);
export default Charity;