// models/Relatorio.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Relatorio = sequelize.define('Relatorio', {
    ID_RELATORIO: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    DESCRICAO: DataTypes.TEXT,
    DATA: DataTypes.DATE,
  }, {
    tableName: 'RELATORIO',
    timestamps: false,
  });

  return Relatorio;
};
