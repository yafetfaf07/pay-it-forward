import createHttpError from "http-errors";
import { UserService } from "../services/UserService";
import createTokens from "../utils/jwt";
import { RequestHandler } from "express";
import mongoose from "mongoose";

export class UserController {
  private _userService: UserService;
  constructor(us: UserService) {
    this._userService = us;
  }
  createUser: RequestHandler<
    unknown,
    unknown,
    { name:string; phone_no: string; }
  > = async (req, res, next) => {
    const {  name, phone_no } = req.body;
    try {
      if ( !name || !phone_no) {
        throw createHttpError(400, "All fields are required");
      }
      const existingUser =
        await this._userService.getUserByPhoneNumber(phone_no);
      if (existingUser) {
        throw createHttpError(409, "User already exists");
      }
      const newUser = await this._userService.createUser(
        name,
        phone_no,
      );
      const {refreshToken } = createTokens(newUser._id);
      res.cookie("token", refreshToken, {
        httpOnly: true,
        secure: false,
        sameSite: "lax",
        maxAge: 7 * 24 * 60 * 60 * 1000,
      });
      res
        .status(201)
        .json({
          token: refreshToken,
          message: "Registration Successful",
          data: newUser,
        });
    } catch (error) {
      console.error(error);
      next(error);
    }
  };
  login:RequestHandler<unknown, unknown, {phone_no:string}>= async(req,res,next) => {
    const phoneNo= req.body.phone_no;
    try {
      if(!phoneNo) {
        throw createHttpError(400, "Phone Number Required");
      }
      const getUser = await this._userService.loginUser(phoneNo);
      if(!getUser) {
        throw createHttpError(404, "User doesn't exist");
      }
      const {refreshToken} = createTokens(getUser._id);
      res.status(200).json({message:"login successful", data:getUser, token:refreshToken});
    } catch (error) {
      
    }
  }
  findUserById:RequestHandler<{id:string}, unknown, unknown>= async(req,res,next) => {
    const id= new mongoose.Types.ObjectId(req.params.id);
    try {
      if(!id) {
        throw createHttpError(400, "User Id Required");
      }
      const getUserName = await this._userService.getUserName(id);
      if(!getUserName) {
        throw createHttpError(404, "User doesn't exist");
      }
      res.status(200).json( {data:getUserName});
    } catch (error) {
      console.error(error);
      next(error);
    }
  }
}
