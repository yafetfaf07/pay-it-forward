import jwt from "jsonwebtoken"
import mongoose from "mongoose"

const createTokens = (userId: mongoose.Types.ObjectId)  => {
    const refreshToken = jwt.sign({id:userId}, process.env.JWT_REFRESH_SECRET!, {expiresIn:"100d"})
return {refreshToken}

}
export default createTokens;


