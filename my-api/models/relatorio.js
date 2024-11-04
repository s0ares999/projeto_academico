// models/Relatorio.js
const { DataTypes } = require('sequelize');

const defineRelatorio = (sequelize) => {
  const Relatorio = sequelize.define('Relatorio', {
    ID_RELATORIO: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    CONTEUDO: DataTypes.TEXT,
    DATA: DataTypes.DATE,
    ID_ATLETA: {
      type: DataTypes.INTEGER,
      references: {
        model: 'ATLETA',
        key: 'ID_ATLETA'
      }
    },
  }, {
    tableName: 'RELATORIO',
    timestamps: false,
  });

  return Relatorio;
};

module.exports = defineRelatorio;
