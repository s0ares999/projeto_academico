// models/EquipaSombra.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const EquipaSombra = sequelize.define('EquipaSombra', {
  ID_EQUIPASOMBRA: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  ID_TIME: DataTypes.INTEGER,
  ID_FORM: DataTypes.INTEGER,
  NOMEEQUIPASOMBRA: DataTypes.TEXT,
  DESCRICAO: DataTypes.TEXT,
  FORMACAO: DataTypes.TEXT,
  CATEGORIA: DataTypes.TEXT,
}, {
  tableName: 'EQUIPASOMBRA',
  timestamps: false,
});

module.exports = EquipaSombra;
