// models/Website.js
const { DataTypes } = require('sequelize');

const defineWebsite = (sequelize) => {
  const Website = sequelize.define('Website', {
    ID_WEBSITE: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    URL: DataTypes.TEXT,
    DESCRICAO: DataTypes.TEXT,
  }, {
    tableName: 'WEBSITE',
    timestamps: false,
  });

  return Website;
};

module.exports = defineWebsite;
