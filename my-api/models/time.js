// models/Time.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Time = sequelize.define('Time', {
    ID_TIME: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    NOME: DataTypes.TEXT,
    CIDADE: DataTypes.TEXT,
  }, {
    tableName: 'TIME',
    timestamps: false,
  });

  // Define associações
  Time.associate = (models) => {
    Time.hasMany(models.Atleta, { foreignKey: 'ID_TIME' });
  };

  return Time;
};
