import createHttpError from "http-errors";
import { RequestHandler } from "express";
import mongoose from "mongoose";
import { PostService } from "../services/PostService";

// ⭐ UPDATED INTERFACE
interface CreatePostBody {
    name: string;
    desc: string;
    // image_url comes from file upload, not body
}

export class PostController {
    private _postService: PostService;

    constructor(ps: PostService) {
        this._postService = ps;
    }

    // ⭐ UPDATED RequestHandler with proper typing
    createPost: RequestHandler<
        { id: string },           // params
        unknown,
        CreatePostBody,           // body
        {}                        // query
    > = async (req, res, next) => {
        // ⭐ SAFE destructuring with defaults
        const { name = '', desc = '' } = req.body || {};
        const id = new mongoose.Types.ObjectId(req.params.id);
        const image_url = req.file ? `uploads/${req.file.filename}` : '';

        try {
            // ⭐ Validation
            if (!name || !desc || !image_url || !id) {
                throw createHttpError(400, "All fields are required");
            }

            const newPost = await this._postService.createPost(
                name,
                desc,
                image_url,
                id
            );

            res.status(201).json({
                message: "Post Created Successfully",
                data: newPost,
            });
        } catch (error) {
            console.error(error);
            next(error);
        }
    }
    getAllPost:RequestHandler<unknown,unknown,unknown,unknown> = async(req,res,next) => {
        const getAllPosts = await this._postService.getAllPosts();
        try {
            if(getAllPosts.length==0) {
                throw createHttpError(404,"Post Not found");
            }
            res.status(200).json({data:getAllPosts});
        } catch (error) {
            console.error(error);
            next(error);
        }
       
        

    }
}