// models/Notificacao.js
const { DataTypes } = require('sequelize');

const defineNotificacao = (sequelize) => {
  const Notificacao = sequelize.define('Notificacao', {
    ID_NOTIFICACAO: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    MENSAGEM: DataTypes.TEXT,
    DATA: DataTypes.DATE,
    LIDA: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
  }, {
    tableName: 'NOTIFICACAO',
    timestamps: false,
  });

  return Notificacao;
};

module.exports = defineNotificacao;
