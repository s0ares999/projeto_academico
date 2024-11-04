// models/Utilizador.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Utilizador = sequelize.define('Utilizador', {
  ID_UTILIZADOR: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  NOME: DataTypes.STRING,
  EMAIL: DataTypes.STRING,
  PASSWORD: DataTypes.STRING,
  ROLE: DataTypes.STRING,
}, {
  tableName: 'UTILIZADOR',
  timestamps: false,
});

module.exports = Utilizador;
