// models/atleta.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Atleta = sequelize.define('Atleta', {
    ID_ATLETA: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    NOME: DataTypes.TEXT,
    DATANASCIMENTO: DataTypes.DATE,
    NACIONALIDADE: DataTypes.TEXT,
    POSICAO: DataTypes.TEXT,
    CLUBE: DataTypes.TEXT,
    LINK: DataTypes.TEXT,
    NOMEAGENTE: DataTypes.TEXT,
    CONTACTOAGENTE: DataTypes.TEXT,
    ANO: DataTypes.INTEGER,
  }, {
    tableName: 'ATLETA',
    timestamps: false,
  });

  return Atleta;
};
