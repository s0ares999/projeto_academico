// models/Utilizador.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Utilizador = sequelize.define('Utilizador', {
    ID_UTILIZADOR: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    NOME: DataTypes.TEXT,
    EMAIL: DataTypes.TEXT,
    SENHA: DataTypes.TEXT,
  }, {
    tableName: 'UTILIZADOR',
    timestamps: false,
  });

  return Utilizador;
};
