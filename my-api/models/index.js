// models/index.js
const { Sequelize } = require('sequelize');
require('dotenv').config(); // Certifique-se de que o dotenv esteja carregado para acessar as variáveis de ambiente

// Configurando a conexão com o banco de dados PostgreSQL
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'postgres', // Defina o dialeto como 'postgres'
});

// Importando os modelos
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

// Definindo as associações
require('./associations')(sequelize);

// Exportando a instância do Sequelize e os modelos
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
