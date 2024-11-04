// models/Relatorio.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Relatorio = sequelize.define('Relatorio', {
  ID_RELATORIO: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  ID_ATLETA: DataTypes.INTEGER,
  TECNICA: DataTypes.INTEGER,
  VELOCIDADE: DataTypes.INTEGER,
  ALTURA: DataTypes.INTEGER,
  MORFOLOGIA: DataTypes.INTEGER,
  INTELIGENCIA: DataTypes.INTEGER,
  RATINGFINAL: DataTypes.INTEGER,
  CREATEDAT: DataTypes.DATE,
  UPDATEDAT: DataTypes.DATE,
  COMENTARIO: DataTypes.TEXT,
}, {
  tableName: 'RELATORIO',
  timestamps: false,
});

module.exports = Relatorio;
