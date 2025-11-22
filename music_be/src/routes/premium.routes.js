const express = require("express");
const router = express.Router();
const premiumController = require("../controllers/premium.controller");

// Kích hoạt gói Premium (mặc định 30 ngày, hoặc truyền days)
router.post("/activate/:id", premiumController.activatePremium);

// Hủy Premium
router.post("/cancel/:id", premiumController.cancelPremium);

// Kiểm tra trạng thái Premium
router.get("/status/:id", premiumController.checkPremium);

module.exports = router;
