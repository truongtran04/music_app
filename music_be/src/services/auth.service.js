require("dotenv").config();
const UserModel = require("../models/user.model");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const admin = require("../config/firebase");

class AuthService {
  // Đăng ký bằng firebase
  static async registerWithFirebase(firebaseToken, extra = {}) {
    // Xác thực token với Firebase
    const decoded = await admin.auth().verifyIdToken(firebaseToken);
    const { uid, name, email, picture } = decoded;

    // Chỉ tạo user nếu chưa có
    let user = await UserModel.findOne({ _id: uid });
    if (user) {
      throw new Error("Account already exists. Please login.");
    }

    user = new UserModel({
      _id: uid,
      name: extra.name || name || "",
      email: email || "",
      avatarUrl: picture || "",
      dateOfBirth: extra.dateOfBirth,
      gender: extra.gender,
    });
    await user.save();

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });
    return { user, token };
  }

  static async loginWithFirebaseEmailPassword(firebaseToken) {
    // Xác thực token với Firebase
    const decoded = await admin.auth().verifyIdToken(firebaseToken);
    const { uid, name, email, picture } = decoded;

    // Chỉ đăng nhập, không tự động tạo user mới
    let user = await UserModel.findOne({ _id: uid });
    if (!user) {
      throw new Error("Account does not exist. Please register first.");
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });
    return { user, token };
  }
}

module.exports = AuthService;
