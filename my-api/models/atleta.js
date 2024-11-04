// models/Atleta.js
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Time = require('./Time');

const Atleta = sequelize.define('Atleta', {
  ID_ATLETA: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  ID_TIME: DataTypes.INTEGER,
  NOME: DataTypes.TEXT,
  DATANASCIMENTO: DataTypes.DATE,
  NACIONALIDADE: DataTypes.TEXT,
  POSICAO: DataTypes.TEXT,
  CLUBE: DataTypes.TEXT,
  LINK: DataTypes.TEXT,
  NOMEAGENTE: DataTypes.TEXT,
  CONTACTOAGENTE: DataTypes.TEXT,
  ANO: DataTypes.INTEGER,
}, {
  tableName: 'ATLETA',
  timestamps: false,
});

// Definindo o relacionamento
Atleta.belongsTo(Time, { foreignKey: 'ID_TIME' });
Time.hasMany(Atleta, { foreignKey: 'ID_TIME' });

module.exports = Atleta;
