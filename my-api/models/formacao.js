// models/Formacao.js
const { DataTypes } = require('sequelize');

const defineFormacao = (sequelize) => {
  const Formacao = sequelize.define('Formacao', {
    ID_FORMACAO: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    NOME: DataTypes.TEXT,
    DESCRICAO: DataTypes.TEXT,
  }, {
    tableName: 'FORMACAO',
    timestamps: false,
  });

  return Formacao;
};

module.exports = defineFormacao;
