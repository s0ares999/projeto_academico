// models/AtletaEquipaSombra.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const AtletaEquipaSombra = sequelize.define('AtletaEquipaSombra', {
    ID_ATLETA_EQUIPA: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    ID_ATLETA: DataTypes.INTEGER,
    ID_EQUIPASOMBRA: DataTypes.INTEGER,
  }, {
    tableName: 'ATLETA_EQUIPA_SOMBRA',
    timestamps: false,
  });

  return AtletaEquipaSombra;
};
