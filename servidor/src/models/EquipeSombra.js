// src/models/EquipeSombra.js
const Sequelize = require('sequelize');
const sequelize = require('../database');
const Formacao = require('./Formacao'); // Ajuste o caminho conforme necessário

const EquipeSombra = sequelize.define('equipeSombra', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    nome: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    descricao: {
        type: Sequelize.STRING,
        allowNull: true,
    },
    categoria: {
        type: Sequelize.STRING,
        allowNull: false,
    },
    formacaoId: {
        type: Sequelize.INTEGER,
        references: {
            model: Formacao,
            key: 'id'
        }
    }
}, {
    timestamps: true, // se você quiser timestamps
});

// Associações
EquipeSombra.belongsTo(Formacao, { foreignKey: 'formacaoId' });
Formacao.hasMany(EquipeSombra, { foreignKey: 'formacaoId' });

module.exports = EquipeSombra;
