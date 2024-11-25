// src/models/Partida.js

const Sequelize = require('sequelize');
const sequelize = require('../database');
const Time = require('./Time');
const Atleta = require('./Atleta');
const Utilizadores = require('./Utilizadores');

const Partida = sequelize.define('partida', {
  id: {
    type: Sequelize.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  data: {  // Campo para a data
    type: Sequelize.DATEONLY,
    allowNull: false,
  },
  hora: {  // Campo para a hora
    type: Sequelize.TIME,
    allowNull: false,
  },
  local: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  timeMandanteId: {
    type: Sequelize.INTEGER,
    references: {
      model: Time,
      key: 'id',
    },
    allowNull: false,
  },
  timeVisitanteId: {
    type: Sequelize.INTEGER,
    references: {
      model: Time,
      key: 'id',
    },
    allowNull: true, // Time visitante é opcional
  },
});

// Relacionamentos
Partida.belongsTo(Time, { as: 'timeMandante', foreignKey: 'timeMandanteId' });
Partida.belongsTo(Time, { as: 'timeVisitante', foreignKey: 'timeVisitanteId' });
Partida.belongsToMany(Atleta, { through: 'PartidaAtletas', as: 'jogadores' });
Partida.belongsToMany(Utilizadores, { through: 'PartidaScouts', as: 'scouts' }); // Novo relacionamento com scouts

module.exports = Partida;
