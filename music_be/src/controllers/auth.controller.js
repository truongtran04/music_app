const AuthService = require("../services/auth.service");

class AuthController {
  // Đăng ký bằng Firebase (Google, Facebook, Email/Password)
  static async registerWithFirebase(req, res) {
    try {
      const { firebaseToken, name, dateOfBirth, gender } = req.body;
      const result = await AuthService.registerWithFirebase(firebaseToken, {
        name,
        dateOfBirth,
        gender,
      });
      res.json(result);
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  }

  // Đăng nhập bằng Firebase (Google, Facebook, Email/Password)
  static async loginWithFirebase(req, res) {
    try {
      const { firebaseToken } = req.body;
      const result = await AuthService.loginWithFirebaseEmailPassword(
        firebaseToken
      );
      res.json(result);
    } catch (err) {
      res.status(401).json({ message: err.message });
    }
  }
}

module.exports = AuthController;
