import mongoose from "mongoose";
import Post from "../models/Post";
export class PostService {
    async createPost(name:string, desc:string, image_url:string, charity_id:mongoose.Types.ObjectId) {
return await Post.create({ name, desc, image_url, charity_id });

    }
    async getAllPosts() {
        return await Post.find().exec();
    }
    // async getPostById(postId: string) {
    //     return await Post.findById(postId).populate('charity_id', 'name email phone_no');
    // }
}