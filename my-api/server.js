const express = require('express');
const { Sequelize } = require('sequelize');
const app = express();
const PORT = process.env.PORT || 3000;

require('dotenv').config();

// Middleware
app.use(express.json());

// Conexão com o PostgreSQL
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'postgres',
});

// Testar a conexão
sequelize.authenticate()
  .then(() => console.log('Conectado ao PostgreSQL'))
  .catch(err => console.error('Erro ao conectar ao PostgreSQL:', err));

// Modelo de dados
const Player = sequelize.define('Player', {
  name: {
    type: Sequelize.STRING,
    allowNull: false,
  },
  age: {
    type: Sequelize.INTEGER,
    allowNull: false,
  },
  team: {
    type: Sequelize.STRING,
    allowNull: false,
  },
});

// Rotas
app.get('/', (req, res) => {
  res.send('API funcionando!');
});

// Criar um jogador
app.post('/players', async (req, res) => {
  try {
    const player = await Player.create(req.body);
    res.status(201).json(player);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Iniciar o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
