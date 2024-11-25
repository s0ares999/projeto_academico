const Sequelize = require('sequelize');
const sequelize = require('../database'); // ajuste o caminho conforme necessário
const Time = require('./Time'); // ajuste o caminho conforme necessário
const Utilizadores = require('./Utilizadores'); // Importa o modelo Utilizadores (Scout)

const Atleta = sequelize.define('atleta', {
    id: {
        type: Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true,
    },
    nome: {
        type: Sequelize.STRING,
        allowNull: false, // Não permite que o campo fique vazio
    },
    dataNascimento: {
        type: Sequelize.DATE,
        allowNull: false, // Não permite que o campo fique vazio
    },
    ano: {
        type: Sequelize.INTEGER,
        allowNull: false, // Não permite que o campo fique vazio
    },
    nacionalidade: {
        type: Sequelize.STRING,
        allowNull: false, // Não permite que o campo fique vazio
    },
    posicao: {
        type: Sequelize.STRING,
        allowNull: false, // Não permite que o campo fique vazio
    },
    clube: {
        type: Sequelize.STRING,
        allowNull: false, // Não permite que o campo fique vazio
    },
    link: {
        type: Sequelize.STRING,
        allowNull: true, // Permite que o campo fique vazio
    },
    agente: {
        type: Sequelize.STRING,
        allowNull: true, // Permite que o campo fique vazio
    },
    contactoAgente: {
        type: Sequelize.STRING,
        allowNull: true, // Permite que o campo fique vazio
    },
    status: {
        type: Sequelize.STRING,
        defaultValue: 'pendente', // Define o status padrão como 'ativo'
    },
}, {
    timestamps: true, // Se não precisar de campos createdAt e updatedAt
});

// Associa o Atleta ao Time
Atleta.belongsTo(Time, { foreignKey: 'timeId', constraints: true, onDelete: 'CASCADE' }); // 'timeId' será a chave estrangeira
Atleta.belongsToMany(Utilizadores, { through: 'ScoutAtleta', foreignKey: 'atletaId' });

module.exports = Atleta;
