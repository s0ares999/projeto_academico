// models/ScoutAtleta.js
const { DataTypes } = require('sequelize');

const defineScoutAtleta = (sequelize) => {
  const ScoutAtleta = sequelize.define('ScoutAtleta', {
    ID_SCOUT: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    ID_ATLETA: {
      type: DataTypes.INTEGER,
      references: {
        model: 'ATLETA',
        key: 'ID_ATLETA'
      }
    },
    NOTAS: DataTypes.TEXT,
    DATA: DataTypes.DATE,
  }, {
    tableName: 'SCOUT_ATLETA',
    timestamps: false,
  });

  return ScoutAtleta;
};

module.exports = defineScoutAtleta;
