// models/index.js
const { Sequelize } = require('sequelize');
const sequelize = require('../config/database');

// Importação dos modelos
const Atleta = require('./atleta')(sequelize);
const Time = require('./time')(sequelize); // Adicionado (sequelize)
const Formacao = require('./formacao')(sequelize); // Adicionado (sequelize)
const Notificacao = require('./notificacao')(sequelize); // Adicionado (sequelize)
const Partida = require('./partida')(sequelize); // Adicionado (sequelize)
const Relatorio = require('./relatorio')(sequelize); // Adicionado (sequelize)
const ScoutAtleta = require('./scoutatleta')(sequelize); // Adicionado (sequelize)
const EquipaSombra = require('./equipasombra')(sequelize); // Adicionado (sequelize)
const AtletaEquipaSombra = require('./atletaequipasombra')(sequelize); // Adicionado (sequelize)
const Utilizador = require('./utilizador')(sequelize); // Adicionado (sequelize)
const Website = require('./website')(sequelize); // Adicionado (sequelize)

// Inicializando os modelos
const models = {
  Atleta,
  Time,
  Formacao,
  Notificacao,
  Partida,
  Relatorio,
  ScoutAtleta,
  EquipaSombra,
  AtletaEquipaSombra,
  Utilizador,
  Website
};

// Definindo associações
require('./associations')(models);

// Exportando a instância do Sequelize e os modelos
module.exports = {
  sequelize,
  ...models, // Usando spread operator para exportar todos os modelos de forma mais limpa
};
