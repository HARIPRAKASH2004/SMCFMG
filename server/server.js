require('dotenv').config(); // Load environment variables
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const compression = require('compression');
const passport = require('passport');
const jwt = require('jsonwebtoken'); // 🔐 Add this
const bcrypt = require('bcrypt'); // For password hashing
const sequelize = require('./config/dbconfig'); // Database connection
const { User, Order, Location, Vehicle, UserLog } = require('./models/models');
const { hashPassword } = require('./middleware/auth'); // ✅ Update path if needed
const argon2 = require('argon2');

const app = express();
const PORT = process.env.PORT || 5000;
const JWT_SECRET = process.env.JWT_SECRET || 'your_secret_key'; // 🔐 Use env or fallback

// ✅ Middleware
app.use(helmet());
app.use(cors());
app.use(compression());
app.use(express.json());
app.use(passport.initialize());

// ✅ Registration with Token Response
app.post(`/api/user/register`, async (req, res) => {
  const { email, username, password, fcmToken } = req.body;

  if (!email || !username || !password) {
    console.log("❌ Missing required fields (email, username, password)");
    return res.status(400).json({ code: 1000, message: "Email, username, and password are required" });
  }

  try {
    console.log("🔍 Checking if the email already exists...");
    const existingUser = await User.findOne({ where: { email } });

    if (existingUser) {
      console.log("❌ Email already exists:", email);
      return res.status(400).json({ code: 1001, message: "Email already exists" });
    }

    console.log("✅ Email not found. Proceeding with password hashing...");
    const hashedPwd = await hashPassword(password);

    let newUser;
    await sequelize.transaction(async (t) => {
      console.log("💼 Starting database transaction...");
      newUser = await User.create({
        email,
        name: username,
        password: hashedPwd,
        type: 'driver',
        state: 'NA',
        district: 'NA',
        age: 0,
        latitude: 0,
        longitude: 0
      }, { transaction: t });

      console.log("✅ New user created with ID:", newUser.id);

      await UserLog.create({
        user_id: newUser.id,
        fcmToken: fcmToken || null
      }, { transaction: t });

      console.log("📱 User log created for FCM token.");
    });

    // 🔐 Generate JWT Token
    const token = jwt.sign({ id: newUser.id, email: newUser.email }, JWT_SECRET, { expiresIn: '7d' });

    console.log("🎉 Registration successful! Sending token.");
    res.setHeader('x-auth-token', token); // ✅ Send token in header
    return res.status(201).json({ message: "Registration successful" });

  } catch (err) {
    console.error("❌ Registration error:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});

// ✅ Login Endpoint
app.post(`/api/user/login`, async (req, res) => {
  const { email, password, fcmToken } = req.body;

  if (!email || !password) {
    console.log("❌ Missing required fields (email, password)");
    return res.status(400).json({ code: 1000, message: "Email and password are required" });
  }

  try {
    console.log("🔍 Checking if user exists for email:", email);
    const user = await User.findOne({ where: { email } });

    if (!user) {
      console.log("❌ No user found with email:", email);
      return res.status(400).json({ code: 1001, message: "Invalid email or password" });
    }

    console.log("🔐 Comparing password...");
    const isMatch = await argon2.verify(user.password, password); // <-- Use argon2 to compare password

    if (!isMatch) {
      console.log("❌ Incorrect password for user:", email);
      return res.status(401).json({ code: 1002, message: "Invalid email or password" });
    }

    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

    if (fcmToken) {
      await UserLog.upsert({ user_id: user.id, fcmToken });
      console.log("📱 FCM token updated in UserLog");
    }

    console.log("✅ Login successful. Sending token...");
    res.setHeader('x-auth-token', token);
    return res.status(200).json({ message: "Login successful" });

  } catch (err) {
    console.error("❌ Login error:", err);
    return res.status(500).json({ message: "Internal server error" });
  }
});


// ✅ (Unchanged) Get User Data
app.get('/api/user/data', passport.authenticate('jwt', { session: false }), async (req, res) => {
  const userId = req.user.id;
  console.log("🔐 Fetching basic user data for ID:", userId);

  try {
    const user = await User.findOne({ where: { id: userId } });

    if (!user) {
      console.log("❌ User not found:", userId);
      return res.status(404).json({ message: 'User not found' });
    }

    const safeUser = {
      id: user.id || 'No ID',
      name: user.name || 'No name',
      email: user.email || 'No email',
      phone: user.phone || 'No phone',
      state: user.state || 'No state',
      district: user.district || 'No district',
      type: user.type || 'driver',
      status: user.status || 'active',
      isOnline: user.isOnline,
      createdAt: user.createdAt || new Date(),
      aadhaarNumber: user.aadhaarNumber || 'No Aadhaar Number',
      updatedAt: user.updatedAt || new Date()
    };

    console.log("🎉 User data fetched successfully:", safeUser);
    return res.status(200).json({ user: safeUser });

  } catch (err) {
    console.error("❌ Error fetching user data:", err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

app.delete('/api/user/logout', passport.authenticate('jwt', { session: false }), async (req, res) => {
  const userId = req.user.id;
  console.log("🔐 Logging out user with ID:", userId);

  try {
    // Delete all UserLog entries for the user
    const deleted = await UserLog.destroy({ where: { user_id: userId } });

    console.log(`🗑️ Deleted ${deleted} log(s) for user ${userId}`);
    return res.status(200).json({ message: 'User logged out and logs removed successfully.' });

  } catch (err) {
    console.error("❌ Error during logout:", err);
    return res.status(500).json({ message: 'Internal server error during logout' });
  }
});





app.put('/api/user/online-status', passport.authenticate('jwt', { session: false }), async (req, res) => {
  const userId = req.user.id;
  const { isOnline } = req.body;

  console.log(`📡 Received online status update for user ID: ${userId} → ${isOnline}`);

  try {
    // Validate input
    if (typeof isOnline !== 'boolean') {
      console.warn("⚠️ Invalid isOnline value received:", isOnline);
      return res.status(400).json({ message: "Missing or invalid 'isOnline' value." });
    }

    const user = await User.findOne({ where: { id: userId } });

    if (!user) {
      console.log("❌ User not found:", userId);
      return res.status(404).json({ message: 'User not found' });
    }

    // Update online status
    user.isOnline = isOnline;
    await user.save();

    console.log(`✅ User ${userId} is now ${user.isOnline ? 'online' : 'offline'}`);
    return res.status(200).json({
      message: `User is now ${user.isOnline ? 'online' : 'offline'}`,
      isOnline: user.isOnline,
    });

  } catch (err) {
    console.error("❌ Error updating online status:", err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});


app.put('/api/user/update-aadhaar', passport.authenticate('jwt', { session: false }), async (req, res) => {
  const userId = req.user.id;
  const { aadhaarNumber } = req.body;

  console.log(`📡 Received Aadhaar number update for user ID: ${userId} → ${aadhaarNumber}`);

  try {
    // Validate input
    if (!aadhaarNumber || typeof aadhaarNumber !== 'string' || aadhaarNumber.length !== 12) {
      console.warn("⚠️ Invalid Aadhaar number received:", aadhaarNumber);
      return res.status(400).json({ message: "Missing or invalid Aadhaar number." });
    }

    const user = await User.findOne({ where: { id: userId } });

    if (!user) {
      console.log("❌ User not found:", userId);
      return res.status(404).json({ message: 'User not found' });
    }

    // Update Aadhaar number
    user.aadhaarNumber = aadhaarNumber;
    await user.save();

    console.log(`✅ User ${userId}'s Aadhaar number updated successfully`);
    return res.status(200).json({
      message: 'Aadhaar number updated successfully',
      aadhaarNumber: user.aadhaarNumber,
    });

  } catch (err) {
    console.error("❌ Error updating Aadhaar number:", err);
    return res.status(500).json({ message: 'Internal server error' });
  }
});

























// ✅ Start Server
sequelize.sync({ alter: true })
  .then(async () => {
    console.log('✅ Database Synced Successfully');

    try {
      await User.sync();
      await Location.sync();
      await Order.sync();
      await Vehicle.sync();
      console.log("🚀 All models synced successfully!");

      app.listen(PORT, () => {
        console.log(`🚀 Server running on port ${PORT}`);
      });
    } catch (syncError) {
      console.error('❌ Error syncing models:', syncError);
    }
  })
  .catch((error) => {
    console.error('❌ Database Sync Error:', error);
  });
