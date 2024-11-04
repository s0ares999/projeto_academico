// models/Notificacao.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Notificacao = sequelize.define('Notificacao', {
    ID_NOTIFICACAO: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    MENSAGEM: DataTypes.TEXT,
    DATA: DataTypes.DATE,
  }, {
    tableName: 'NOTIFICACAO',
    timestamps: false,
  });

  return Notificacao;
};
