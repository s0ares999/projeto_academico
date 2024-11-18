require('dotenv').config(); // Carrega variáveis de ambiente

const { Sequelize } = require('sequelize');

// Certifique-se de que a variável DATABASE_URL está sendo lida corretamente
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'postgres',
  protocol: 'postgres',
  logging: false,
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false, // Para aceitar certificados não verificados
    },
  },
});

module.exports = { sequelize }; // Exporte a instância do sequelize
