// models/Partida.js
const { DataTypes } = require('sequelize');

const definePartida = (sequelize) => {
  const Partida = sequelize.define('Partida', {
    ID_PARTIDA: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    DATA: DataTypes.DATE,
    LOCAL: DataTypes.TEXT,
    ID_TIME_LOCAL: {
      type: DataTypes.INTEGER,
      references: {
        model: 'TIME',
        key: 'ID_TIME'
      }
    },
    ID_TIME_VISITANTE: {
      type: DataTypes.INTEGER,
      references: {
        model: 'TIME',
        key: 'ID_TIME'
      }
    },
    RESULTADO: DataTypes.TEXT,
  }, {
    tableName: 'PARTIDA',
    timestamps: false,
  });

  return Partida;
};

module.exports = definePartida;
