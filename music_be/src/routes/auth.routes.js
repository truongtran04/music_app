const express = require("express");
const AuthController = require("../controllers/auth.controller");
const router = express.Router();

// Đăng ký bằng Firebase (Google, Facebook, Email/Password)
router.post("/firebase-register", AuthController.registerWithFirebase);

// Đăng nhập bằng Firebase (Google, Facebook, Email/Password)
router.post("/firebase-login", AuthController.loginWithFirebase);

module.exports = router;
