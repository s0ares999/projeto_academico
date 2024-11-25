// src/models/AtletasEquipeSombra.js
const Sequelize = require('sequelize');
const sequelize = require('../database'); // Ajuste o caminho conforme necessário
const Atleta = require('./Atleta'); // Ajuste o caminho conforme necessário
const EquipeSombra = require('./EquipeSombra'); // Ajuste o caminho conforme necessário

const AtletasEquipeSombra = sequelize.define('atletas_equipe_sombra', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    atletaId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
            model: Atleta,
            key: 'id'
        }
    },
    equipeSombraId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
            model: EquipeSombra,
            key: 'id'
        }
    }
}, {
    timestamps: false, // Defina como true se você usar createdAt e updatedAt
});

// Associações
AtletasEquipeSombra.belongsTo(Atleta, { foreignKey: 'atletaId', as: 'atleta' });
AtletasEquipeSombra.belongsTo(EquipeSombra, { foreignKey: 'equipeSombraId', as: 'equipeSombra' });

module.exports = AtletasEquipeSombra;
