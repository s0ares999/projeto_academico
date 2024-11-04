// models/ScoutAtleta.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ScoutAtleta = sequelize.define('ScoutAtleta', {
  ID_UTILIZADOR: { type: DataTypes.INTEGER, primaryKey: true },
  ID_RELATORIO: { type: DataTypes.INTEGER, primaryKey: true },
}, {
  tableName: 'SCOUTATLETA',
  timestamps: false,
});

module.exports = ScoutAtleta;
