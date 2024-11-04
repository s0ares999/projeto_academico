// models/Time.js
const { DataTypes } = require('sequelize');

const defineTime = (sequelize) => {
  const Time = sequelize.define('Time', {
    ID_TIME: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    NOME: DataTypes.TEXT,
    ESTADIO: DataTypes.TEXT,
    NOME_TREINADOR: DataTypes.TEXT,
    ANO_FUNDACAO: DataTypes.INTEGER,
    LINK: DataTypes.TEXT,
  }, {
    tableName: 'TIME',
    timestamps: false,
  });

  // Associações
  Time.associate = (models) => {
    Time.hasMany(models.Atleta, { foreignKey: 'ID_TIME' });
  };

  return Time;
};

module.exports = defineTime;
