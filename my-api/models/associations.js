// models/associations.js
const Atleta = require('./atleta');
const Time = require('./time');
const ScoutAtleta = require('./scoutatleta');
const AtletaEquipaSombra = require('./atletaequipasombra');

// Função para definir associações
const defineAssociations = (models) => {
  // Associações Atleta
  Atleta.associate(models);

  // Associações Time
  Time.associate(models);
  
  // Associações ScoutAtleta
  ScoutAtleta.associate(models);
  
  // Associações AtletaEquipaSombra
  AtletaEquipaSombra.associate(models);
};

// Exportando a função
module.exports = defineAssociations;
