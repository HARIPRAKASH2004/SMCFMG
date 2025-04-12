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


// ✅ (Unchanged) Get User Data
app.get('/api/user/data', passport.authenticate('jwt', { session: false }), async (req, res) => {
  const userId = req.user.id;
  console.log("🔐 Fetching data for user with ID:", userId);

  try {
    const [user, vehicle, currentOrder, location] = await Promise.all([
      User.findOne({ where: { id: userId } }),
      Vehicle.findOne({ where: { userId } }),
      Order.findOne({ where: { driverId: userId, status: 'assigned' } }),
      Location.findOne({ where: { userId }, order: [['createdAt', 'DESC']] })
    ]);

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
      createdAt: user.createdAt || new Date(),
      updatedAt: user.updatedAt || new Date()
    };

    const safeVehicle = vehicle && vehicle.id ? {
      id: vehicle.id || 'No vehicle ID',
      userId: vehicle.userId || userId,
      vehicleNumber: vehicle.vehicleNumber || 'No vehicle',
      vehicleType: vehicle.vehicleType || 'N/A',
      model: vehicle.model || '',
      brand: vehicle.brand || '',
      year: vehicle.year || 0,
      rcBookUrl: vehicle.rcBookUrl || '',
      insuranceUrl: vehicle.insuranceUrl || '',
      insuranceExpiry: vehicle.insuranceExpiry || new Date(),
      status: vehicle.status || 'inactive',
      createdAt: vehicle.createdAt || new Date(),
      updatedAt: vehicle.updatedAt || new Date()
    } : {
      id: 'No vehicle ID',
      userId: userId,
      vehicleNumber: 'No vehicle',
      vehicleType: 'N/A',
      model: '',
      brand: '',
      year: 0,
      rcBookUrl: '',
      insuranceUrl: '',
      insuranceExpiry: new Date(),
      status: 'inactive',
      createdAt: new Date(),
      updatedAt: new Date()
    };

    const safeOrder = currentOrder && currentOrder.orderId ? {
      orderId: currentOrder.orderId || 'No order ID',
      driverId: currentOrder.driverId || userId,
      status: currentOrder.status || 'no_order',
      fare: currentOrder.fare || 0,
      pickupTime: currentOrder.pickupTime || new Date(),
      distanceInKm: currentOrder.distanceInKm || 0,
      loadWeightInTons: currentOrder.loadWeightInTons || 0,
      goodsType: currentOrder.goodsType || '',
      notes: currentOrder.notes || '',
      createdAt: currentOrder.createdAt || new Date(),
      updatedAt: currentOrder.updatedAt || new Date()
    } : {
      orderId: 'No order ID',
      driverId: userId,
      status: 'no_order',
      fare: 0,
      pickupTime: new Date(),
      distanceInKm: 0,
      loadWeightInTons: 0,
      goodsType: '',
      notes: '',
      createdAt: new Date(),
      updatedAt: new Date()
    };

    const safeLocation = location && location.latitude ? {
      latitude: location.latitude || 0,
      longitude: location.longitude || 0,
      address: location.address || 'No address',
      lastUpdated: location.lastUpdated || new Date(),
      createdAt: location.createdAt || new Date(),
      updatedAt: location.updatedAt || new Date()
    } : {
      latitude: 0,
      longitude: 0,
      address: 'No address',
      lastUpdated: new Date(),
      createdAt: new Date(),
      updatedAt: new Date()
    };

    const userData = {
      user: safeUser,
      vehicle: safeVehicle,
      currentOrder: safeOrder,
      location: safeLocation
    };

    console.log("🎉 User data fetched successfully:", userData);
    return res.status(200).json(userData);
  } catch (err) {
    console.error("❌ Error fetching user data:", err);
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
