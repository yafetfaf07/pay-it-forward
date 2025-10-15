import createHttpError from "http-errors";
import User from "../models/User";
import { UserService } from "../services/UserService";
import createTokens from "../utils/jwt";
import { RequestHandler } from "express";

export class UserController {
  private _userService: UserService;
  constructor(us: UserService) {
    this._userService = us;
  }
  createUser: RequestHandler<
    unknown,
    unknown,
    { fname: string; lname: string; phone_no: string; password: string }
  > = async (req, res, next) => {
    const { fname, lname, phone_no, password } = req.body;
    try {
      if (!fname || !lname || !phone_no || !password) {
        throw createHttpError(400, "All fields are required");
      }
      const existingUser =
        await this._userService.getUserByPhoneNumber(phone_no);
      if (existingUser) {
        throw createHttpError(409, "User already exists");
      }
      const newUser = await this._userService.createUser(
        fname,
        lname,
        phone_no,
        password
      );
      const { accessToken, refreshToken } = createTokens(newUser._id);
      res.cookie("token", refreshToken, {
        httpOnly: true,
        secure: false,
        sameSite: "lax",
        maxAge: 7 * 24 * 60 * 60 * 1000,
      });
      res
        .status(201)
        .json({
          token: accessToken,
          message: "Registration Successful",
          data: newUser,
        });
    } catch (error) {
      console.error(error);
      next(error);
    }
  };
}
