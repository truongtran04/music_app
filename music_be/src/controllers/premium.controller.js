const premiumService = require("../services/premium.service");

const activatePremium = async (req, res) => {
  try {
    const userId = req.params.id;
    const days = req.body.days || 30;

    const user = await premiumService.activatePremium(userId, days);
    res.json({ message: "Premium activated", user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const cancelPremium = async (req, res) => {
  try {
    const userId = req.params.id;
    const user = await premiumService.cancelPremium(userId);
    res.json({ message: "Premium canceled", user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const checkPremium = async (req, res) => {
  try {
    const userId = req.params.id;
    const status = await premiumService.checkPremiumStatus(userId);
    res.json(status);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  activatePremium,
  cancelPremium,
  checkPremium,
};
