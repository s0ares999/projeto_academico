/*require('dotenv').config(); // Carregar variáveis de ambiente do arquivo .env
const { Sequelize } = require('sequelize');

// Verificar se a aplicação está rodando em ambiente de produção
const isProduction = process.env.NODE_ENV === 'production';

// Verificar se as variáveis de ambiente necessárias estão definidas
if (!process.env.DB_NAME || !process.env.DB_USER || !process.env.DB_PASSWORD || !process.env.DB_HOST) {
  console.error('Erro: Variáveis de ambiente para configuração do banco de dados estão ausentes.');
  process.exit(1); // Finaliza o processo se houver falta de variáveis essenciais
}

// Configuração do Sequelize
const sequelize = new Sequelize(
  process.env.DB_NAME,     // Nome do banco de dados
  process.env.DB_USER,     // Usuário do banco
  process.env.DB_PASSWORD, // Senha do banco
  {
    host: process.env.DB_HOST,        // Host do banco
    port: process.env.DB_PORT || 5432, // Porta padrão do PostgreSQL
    dialect: 'postgres',             // Dialeto do banco
    logging: isProduction ? false : console.log, // Logar queries apenas em ambiente de desenvolvimento
    dialectOptions: isProduction
      ? {
          ssl: {
            require: true,              // SSL obrigatório em produção
            rejectUnauthorized: false, // Ignorar erros de certificado SSL
          },
        }
      : {}, // Sem configurações de SSL em ambiente local
  }
);

// Teste de conexão com o banco
(async () => {
  try {
    await sequelize.authenticate();
    console.log('Conexão com o banco de dados estabelecida com sucesso.');
  } catch (error) {
    console.error('Erro ao conectar ao banco de dados:', error);
    process.exit(1); // Finaliza o processo em caso de erro na conexão
  }
})();

module.exports = sequelize;
*/

var Sequelize = require('sequelize');
const sequelize = new Sequelize(
    'API4',
    'postgres',
    'postgres',
    {
        host: 'localhost',
        port: '5432',
        dialect: 'postgres'
    }
);

module.exports = sequelize;
