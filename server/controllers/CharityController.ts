import createHttpError from "http-errors";
import Charity from "../models/Charity";
import { CharityService } from "../services/CharityService";
import { RequestHandler } from "express";
import createTokens from "../utils/jwt";

export class CharityController {
  private _charityService: CharityService;
  constructor(cs: CharityService) {
    this._charityService = cs;
  }
  createCharity: RequestHandler<
    unknown,
    unknown,
    { name: string; phone_no: string;}
  > = async (req, res, next) => {
    const { name, phone_no } = req.body;
    try {
      if (!name || !phone_no) {
        throw createHttpError(400, "All fields are required");
      }
      const existingCharity =
        await Charity.findOne({ phone_no }).exec();
      if (existingCharity) {
        throw createHttpError(409, "Charity already exists");
      }
      const newCharity = await this._charityService.createCharity(
        name,
        phone_no
      );
              const {refreshToken } = createTokens(newCharity._id);
              res.cookie("token", refreshToken, {
                httpOnly: true,
                secure: false,
                sameSite: "lax",
                maxAge: 7 * 24 * 60 * 60 * 1000,
              });
      res
        .status(201)
        .json({
          message: "Charity Created Successfully",
          data: newCharity,
          token:refreshToken
        });
    } catch (error) {
      console.error(error);
      next(error);
    }
  }
  login:RequestHandler<unknown, unknown, {phone_no:string}>= async(req,res,next) => {
    const phoneNo= req.body.phone_no;
    try {
      if(!phoneNo) {
        throw createHttpError(400, "Phone Number Required");
      }
      const getCharity = await this._charityService.loginCharity(phoneNo);
      if(!getCharity) {
        throw createHttpError(404, "Charity doesn't exist");
      }
        const {refreshToken } = createTokens(getCharity._id);
            res.cookie("token", refreshToken, {
              httpOnly: true,
              secure: false,
              sameSite: "lax",
              maxAge: 7 * 24 * 60 * 60 * 1000,
            });
      res.status(200).json({message:"login successful", data:getCharity, token:refreshToken});
    } catch (error) {
      console.error(error);
      next(error);
    }
  }
}