// models/index.js
const sequelize = require('../config/database');

// Carrega cada modelo
const Atleta = require('./atleta')(sequelize);
const Time = require('./time')(sequelize);
const Formacao = require('./formacao')(sequelize);
const Notificacao = require('./notificacao')(sequelize);
const Partida = require('./partida')(sequelize);
const Relatorio = require('./relatorio')(sequelize);
const ScoutAtleta = require('./scoutatleta')(sequelize);
const EquipaSombra = require('./equipasombra')(sequelize);
const AtletaEquipaSombra = require('./atletaequipasombra')(sequelize);
const Utilizador = require('./utilizador')(sequelize);
const Website = require('./website')(sequelize);

// Inicializa todos os modelos em um objeto para usar nas associações
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
  Website,
};

// Define as associações usando a função `associate` de cada modelo
require('./associations')(models);

module.exports = { sequelize, ...models };
