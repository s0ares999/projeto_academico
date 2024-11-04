// models/Formacao.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Formacao = sequelize.define('Formacao', {
  ID_FORM: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  NOME: DataTypes.TEXT,
}, {
  tableName: 'FORMACAO',
  timestamps: false,
});

module.exports = Formacao;
