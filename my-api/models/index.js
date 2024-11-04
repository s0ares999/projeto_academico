// models/index.js
const { Sequelize } = require('sequelize');
const sequelize = new Sequelize(/* Configurações de conexão */);

const Atleta = require('./atleta')(sequelize);
const Time = require('./Time')(sequelize);
const Formacao = require('./Formacao')(sequelize);
const Notificacao = require('./Notificacao')(sequelize);
const Partida = require('./Partida')(sequelize);
const Relatorio = require('./Relatorio')(sequelize);
const ScoutAtleta = require('./ScoutAtleta')(sequelize);
const EquipaSombra = require('./EquipaSombra')(sequelize);
const AtletaEquipaSombra = require('./atletaequipasombra.js')(sequelize);
const Utilizador = require('./Utilizador')(sequelize);
const Website = require('./Website')(sequelize);

// Defina as associações
require('./associations')(sequelize);

module.exports = {
  sequelize,
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
