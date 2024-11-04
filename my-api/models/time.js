// models/Time.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Time = sequelize.define('Time', {
    ID_TIME: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    NOME: DataTypes.TEXT,
    LOCALIDADE: DataTypes.TEXT,
  }, {
    tableName: 'TIME',
    timestamps: false,
  });

  return Time;
};
