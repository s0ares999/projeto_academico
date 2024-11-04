// models/Website.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Website = sequelize.define('Website', {
  ID_WEBSITE: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  URL: DataTypes.STRING,
}, {
  tableName: 'WEBSITE',
  timestamps: false,
});

module.exports = Website;
