// models/EquipaSombra.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const EquipaSombra = sequelize.define('EquipaSombra', {
    ID_EQUIPASOMBRA: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    NOME: DataTypes.TEXT,
  }, {
    tableName: 'EQUIPA_SOMBRA',
    timestamps: false,
  });

  return EquipaSombra;
};
