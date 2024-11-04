// server.js
const express = require('express');
const { Sequelize } = require('sequelize');
const app = express();
const PORT = process.env.PORT || 3000;
const db = require('./models'); // Importa os models
require('./models/associations'); // Configura as associações

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

// Rotas
app.get('/', (req, res) => {
  res.send('API funcionando!');
});

// Criar um jogador
app.post('/players', async (req, res) => {
  try {
    const player = await db.Atleta.create(req.body); // Altere para o seu modelo
    res.status(201).json(player);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Obter todos os jogadores
app.get('/players', async (req, res) => {
  try {
    const players = await db.Atleta.findAll(); // Altere para o seu modelo
    res.status(200).json(players);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Obter um jogador específico
app.get('/players/:id', async (req, res) => {
  try {
    const player = await db.Atleta.findByPk(req.params.id); // Altere para o seu modelo
    if (player) {
      res.status(200).json(player);
    } else {
      res.status(404).json({ error: 'Jogador não encontrado' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Atualizar um jogador
app.put('/players/:id', async (req, res) => {
  try {
    const player = await db.Atleta.findByPk(req.params.id); // Altere para o seu modelo
    if (player) {
      await player.update(req.body);
      res.status(200).json(player);
    } else {
      res.status(404).json({ error: 'Jogador não encontrado' });
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Deletar um jogador
app.delete('/players/:id', async (req, res) => {
  try {
    const player = await db.Atleta.findByPk(req.params.id); // Altere para o seu modelo
    if (player) {
      await player.destroy();
      res.status(204).send(); // No Content
    } else {
      res.status(404).json({ error: 'Jogador não encontrado' });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Iniciar o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
