// models/Time.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Time = sequelize.define('Time', {
  ID_TIME: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  NOMETIME: DataTypes.TEXT,
  NUMEROIDENTIFICACAO: DataTypes.TEXT,
  CIDADE: DataTypes.TEXT,
  PAIS: DataTypes.TEXT,
  CATEGORIA: DataTypes.TEXT,
  DESCRICAO: DataTypes.TEXT,
}, {
  tableName: 'TIME',
  timestamps: false,
});

module.exports = Time;
