import jwt from "jsonwebtoken"
import mongoose from "mongoose"

const createTokens = (userId: mongoose.Types.ObjectId)  => {
    const accessToken = jwt.sign({id:userId}, process.env.JWT_TOKEN!, {expiresIn:"15m"})
    const refreshToken = jwt.sign({id:userId}, process.env.JWT_REFRESH_SECRET!, {expiresIn:"7d"})
return {accessToken,refreshToken}

}
export default createTokens;


