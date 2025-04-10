require('dotenv').config(); // Load environment variables
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const compression = require('compression');
const passport = require('passport');
const sequelize = require('./config/dbconfig'); // Database connection
const { User, Order, Location, Vehicle } = require('./models/models'); // Import models

const app = express();

// ✅ Middleware
app.use(helmet()); // Security headers
app.use(cors()); // Enable Cross-Origin Resource Sharing
app.use(compression()); // Compress responses for speed
app.use(express.json()); // Parse JSON request bodies
app.use(passport.initialize()); // Initialize authentication

const PORT = process.env.PORT || 5000; // ✅ Define PORT before using it

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});

sequelize.sync({ alter: true }) 
  .then(async () => {
    console.log('✅ Database Synced Successfully');

    await User.sync();   // Ensure the User table is created first
    await Location.sync(); // Then Location (which depends on User)
    await Order.sync();   // Then Orders (which depend on Users)
    await Vehicle.sync(); // Finally, Vehicles (which depend on Users)

    app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
  })
  .catch((error) => {
    console.error('❌ Database Sync Error:', error);
  });
