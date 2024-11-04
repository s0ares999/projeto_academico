// models/index.js
const { Sequelize } = require('sequelize');
const sequelize = require('../config/database');

// Importação dos modelos
const Atleta = require('./atleta')(sequelize);
const Time = require('./time');
const Formacao = require('./formacao');
const Notificacao = require('./notificacao');
const Partida = require('./partida');
const Relatorio = require('./relatorio');
const ScoutAtleta = require('./scoutatleta');
const EquipaSombra = require('./equipasombra');
const AtletaEquipaSombra = require('./atletaequipasombra');
const Utilizador = require('./utilizador');
const Website = require('./website');

// Inicializando os modelos
const models = {
  Atleta: Atleta(sequelize),
  Time: Time(sequelize),
  Formacao: Formacao(sequelize),
  Notificacao: Notificacao(sequelize),
  Partida: Partida(sequelize),
  Relatorio: Relatorio(sequelize),
  ScoutAtleta: ScoutAtleta(sequelize),
  EquipaSombra: EquipaSombra(sequelize),
  AtletaEquipaSombra: AtletaEquipaSombra(sequelize),
  Utilizador: Utilizador(sequelize),
  Website: Website(sequelize)
};

// Definindo associações
require('./associations')(models);

// Exportando a instância do Sequelize e os modelos
module.exports = {
  sequelize,
  ...models, // Usando spread operator para exportar todos os modelos de forma mais limpa
};
