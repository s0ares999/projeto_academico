// models/Notificacao.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Notificacao = sequelize.define('Notificacao', {
  ID_NOTI: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  ID_UTILIZADOR: DataTypes.INTEGER,
  TITULO: DataTypes.TEXT,
  MENSAGEM: DataTypes.TEXT,
}, {
  tableName: 'NOTIFICACAO',
  timestamps: false,
});

module.exports = Notificacao;
