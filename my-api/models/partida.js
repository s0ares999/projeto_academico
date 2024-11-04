// models/Partida.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Partida = sequelize.define('Partida', {
    ID_PARTIDA: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    DATA: DataTypes.DATE,
    TIME1: DataTypes.INTEGER,
    TIME2: DataTypes.INTEGER,
    RESULTADO: DataTypes.TEXT,
  }, {
    tableName: 'PARTIDA',
    timestamps: false,
  });

  return Partida;
};
