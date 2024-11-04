// models/AtletaEquipaSombra.js
const { DataTypes } = require('sequelize');

const defineAtletaEquipaSombra = (sequelize) => {
  const AtletaEquipaSombra = sequelize.define('AtletaEquipaSombra', {
    ID: {
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
    ID_EQUIPA: {
      type: DataTypes.INTEGER,
      references: {
        model: 'EQUIPA_SOMBRA',
        key: 'ID_EQUIPA'
      }
    },
  }, {
    tableName: 'ATLETA_EQUIPA_SOMBRA',
    timestamps: false,
  });

  return AtletaEquipaSombra;
};

module.exports = defineAtletaEquipaSombra;
