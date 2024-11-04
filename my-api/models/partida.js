// models/Partida.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Partida = sequelize.define('Partida', {
  ID_PARTIDA: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  LOCAL: DataTypes.TEXT,
  RESULTADO: DataTypes.INTEGER,
  DIADOJOGO: DataTypes.DATE,
}, {
  tableName: 'PARTIDA',
  timestamps: false,
});

module.exports = Partida;
