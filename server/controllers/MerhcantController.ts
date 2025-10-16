import createHttpError from "http-errors";
import Merchant from "../models/Merchant";
import { MerchantService } from "../services/MerchantService";
import { RequestHandler } from "express";
import createTokens from "../utils/jwt";

export class MerchantController {
  private _merchantService: MerchantService;
  constructor(ms: MerchantService) {
    this._merchantService = ms;
  }
  createMerchant: RequestHandler<
    unknown,
    unknown,
    { name: string; phone_no: string }
  > = async (req, res, next) => {
    const { name, phone_no } = req.body;
    try {
      if (!name || !phone_no) {
        throw createHttpError(400, "All fields are required");
      }
      const existingMerchant =
        await Merchant.findOne({ phone_no }).exec();
      if (existingMerchant) {
        throw createHttpError(409, "Merchant already exists");
      }
      const newMerchant = await this._merchantService.createMerchant(
        name,
        phone_no
      );
        const {refreshToken } = createTokens(newMerchant._id);
            res.cookie("token", refreshToken, {
              httpOnly: true,
              secure: false,
              sameSite: "lax",
              maxAge: 7 * 24 * 60 * 60 * 1000,
            });
      res
        .status(201)
        .json({
          message: "Merchant Created Successfully",
          data: newMerchant,
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
      const getMerchant = await this._merchantService.loginMerchant(phoneNo);
      if(!getMerchant) {
        throw createHttpError(404, "Merchant doesn't exist");
      }
        const {refreshToken } = createTokens(getMerchant._id);
            res.cookie("token", refreshToken, {
              httpOnly: true,
              secure: false,
              sameSite: "lax",
              maxAge: 7 * 24 * 60 * 60 * 1000,
            });
      res.status(200).json({message:"login successful", data:getMerchant, token:refreshToken});
    } catch (error) {
      console.error(error);
      next(error);
    }
  }
}