import {model,Schema} from "mongoose";

const postSchema = new Schema({
    name: {type: String, required: true},
    desc: {type: String, required: true, select:false},
    image_url: {type: String, required: true,},
    charity_id:{type:Schema.Types.ObjectId, required:true, ref:'Charity'},
    date:{type:Date, default:Date.now}
});

const Post = model('Post', postSchema);
export default Post;