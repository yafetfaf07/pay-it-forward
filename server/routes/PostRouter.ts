import { PostController } from "../controllers/PostController";
import express from "express";
import { upload } from '../middlewares/multerconfig';

export class PostRouter {
    private _postController: PostController;
    router;
    constructor(pc: PostController) {
        this._postController = pc;
        this.router = express.Router();
    }
    registerRoutes() {
        this.router.post("/createPost/:id",
            upload.single('file'),
            this._postController.createPost);
        return this.router;
    }
}