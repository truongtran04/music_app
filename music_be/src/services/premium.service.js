const User = require("../models/user.model");

const activatePremium = async (userId, days = 30) => {
  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + days);

  const updatedUser = await User.findByIdAndUpdate(
    userId,
    {
      isPremium: true,
      premiumExpiresAt: expiresAt,
    },
    { new: true }
  );

  return updatedUser;
};

const cancelPremium = async (userId) => {
  const updatedUser = await User.findByIdAndUpdate(
    userId,
    {
      isPremium: false,
      premiumExpiresAt: null,
    },
    { new: true }
  );

  return updatedUser;
};

const checkPremiumStatus = async (userId) => {
  const user = await User.findById(userId);
  if (!user) throw new Error("User not found");

  const isExpired =
    user.premiumExpiresAt && new Date(user.premiumExpiresAt) < new Date();

  if (isExpired) {
    await cancelPremium(userId);
    return { isPremium: false };
  }

  return { isPremium: user.isPremium };
};

module.exports = {
  activatePremium,
  cancelPremium,
  checkPremiumStatus,
};
