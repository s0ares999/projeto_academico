// models/ScoutAtleta.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const ScoutAtleta = sequelize.define('ScoutAtleta', {
    ID_SCOUT: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    ID_ATLETA: DataTypes.INTEGER,
    AVALIACAO: DataTypes.TEXT,
  }, {
    tableName: 'SCOUT_ATLETA',
    timestamps: false,
  });

  return ScoutAtleta;
};
