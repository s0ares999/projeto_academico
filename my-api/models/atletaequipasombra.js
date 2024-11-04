// models/AtletaEquipaSombra.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const AtletaEquipaSombra = sequelize.define('AtletaEquipaSombra', {
  ID_EQUIPASOMBRA: { type: DataTypes.INTEGER, primaryKey: true },
  ID_ATLETA: { type: DataTypes.INTEGER, primaryKey: true },
}, {
  tableName: 'ATLETAEQUIPESOMBRA',
  timestamps: false,
});

module.exports = AtletaEquipaSombra;
