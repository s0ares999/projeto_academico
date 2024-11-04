// models/Website.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Website = sequelize.define('Website', {
    ID_WEBSITE: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    URL: DataTypes.TEXT,
    DESCRICAO: DataTypes.TEXT,
  }, {
    tableName: 'WEBSITE',
    timestamps: false,
  });

  return Website;
};
