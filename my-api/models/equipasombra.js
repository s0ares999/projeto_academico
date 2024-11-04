// models/EquipaSombra.js
const { DataTypes } = require('sequelize');

const defineEquipaSombra = (sequelize) => {
  const EquipaSombra = sequelize.define('EquipaSombra', {
    ID_EQUIPA: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    NOME: DataTypes.TEXT,
    DESCRICAO: DataTypes.TEXT,
  }, {
    tableName: 'EQUIPA_SOMBRA',
    timestamps: false,
  });

  return EquipaSombra;
};

module.exports = defineEquipaSombra;
