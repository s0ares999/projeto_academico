// models/Atleta.js
const { DataTypes } = require('sequelize');

const defineAtleta = (sequelize) => {
  const Atleta = sequelize.define('Atleta', {
    ID_ATLETA: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
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

  // Associações
  Atleta.associate = (models) => {
    Atleta.belongsTo(models.Time, { foreignKey: 'ID_TIME' });
  };

  return Atleta;
};

module.exports = defineAtleta;
