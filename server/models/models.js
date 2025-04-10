const { DataTypes } = require('sequelize');
const sequelize = require('../config/dbconfig'); // Import Sequelize instance

// ✅ Driver Model (User Table)
const User = sequelize.define('User', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  googleId: { // For Google OAuth users
    type: DataTypes.STRING,
    allowNull: true, // Null for email/password users
    unique: true,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  age: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
    },
  },
  phone: {
    type: DataTypes.STRING,
    allowNull: true,
    unique: true,
  },
  password: { 
    type: DataTypes.STRING,
    allowNull: true, // Null for Google users
  },
  state: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  district: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  type: {
    type: DataTypes.ENUM('driver', 'admin'),
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('active', 'inactive', 'blocked'),
    defaultValue: 'active',
  },
  latitude: {
    type: DataTypes.DOUBLE,
    allowNull: false,
  },
  longitude: {
    type: DataTypes.DOUBLE,
    allowNull: false,
  },
  lastUpdated: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW,
  },
  isOnline: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  availability: {
    type: DataTypes.ENUM('available', 'on_trip', 'unavailable'),
    defaultValue: 'available',
  },
  currentOrderId: {
    type: DataTypes.UUID,
    allowNull: true,
  },
  totalOrdersCompleted: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  rating: {
    type: DataTypes.DOUBLE,
    defaultValue: 0.0,
  },
  fcmToken: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  profileImageUrl: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
});

// ✅ Location Model (Driver Tracking)
const Location = sequelize.define('Location', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'User',
      key: 'id',
    },
  },
  latitude: {
    type: DataTypes.DOUBLE,
    allowNull: false,
  },
  longitude: {
    type: DataTypes.DOUBLE,
    allowNull: false,
  },
  address: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  lastUpdated: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
    allowNull: false,
  },
}, {
  timestamps: true, // Automatically adds `createdAt` and `updatedAt`
});





const Order = sequelize.define('Order', {
  orderId: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  driverId: { // Only Drivers receive orders
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'User',
      key: 'id',
    },
  },
  assignedByAdminId: { // Admin who assigned the order
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'User',
      key: 'id',
    },
  },
  driverName: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  pickupLocation: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  deliveryLocation: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('pending', 'assigned', 'delivered', 'cancelled'),
    defaultValue: 'pending',
  },
  pickupTime: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  deliveryTime: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  distanceInKm: {
    type: DataTypes.FLOAT,
    allowNull: false,
    defaultValue: 0,
  },
  loadWeightInTons: {
    type: DataTypes.FLOAT,
    allowNull: false,
    defaultValue: 0,
  },
  goodsType: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  fare: {
    type: DataTypes.FLOAT,
    allowNull: false,
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
});



// ✅ Vehicle Model (NEW)

const Vehicle = sequelize.define('Vehicle', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  userId: { // Driver ID
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'User',
      key: 'id',
    },
  },
  vehicleNumber: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  vehicleType: {
    type: DataTypes.ENUM('lorry', 'mini-truck', 'trailer'),
    allowNull: false,
  },
  model: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  brand: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  year: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  rcBookUrl: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  insuranceUrl: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  insuranceExpiry: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  status: {
    type: DataTypes.ENUM('active', 'inactive', 'in_maintenance'),
    defaultValue: 'active',
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
  updatedAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
});

// ✅ Associations
User.hasOne(Location, { foreignKey: 'userId', onDelete: 'CASCADE' });
Location.belongsTo(User, { foreignKey: 'userId', onDelete: 'CASCADE' });

User.hasMany(Order, { foreignKey: 'driverId', as: 'orders' });
Order.belongsTo(User, { foreignKey: 'driverId', as: 'driver' });

User.hasMany(Order, { foreignKey: 'assignedByAdminId', as: 'assignedOrders' });
Order.belongsTo(User, { foreignKey: 'assignedByAdminId', as: 'admin' });

User.hasOne(Vehicle, { foreignKey: 'userId', as: 'vehicle', onDelete: 'CASCADE' });
Vehicle.belongsTo(User, { foreignKey: 'userId', as: 'driver' });

// ✅ Export Models
module.exports = {
  User,
  Location,
  Order,
  Vehicle,
};
