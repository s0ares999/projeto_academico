// server.js
const express = require('express');
const db = require('./models'); // Importa os models
const app = express();
const PORT = process.env.PORT || 3000;

require('dotenv').config(); // Carrega as variáveis de ambiente

// Middleware
app.use(express.json());

// Testar a conexão com o banco de dados
db.sequelize.authenticate()
  .then(() => console.log('Conectado ao PostgreSQL'))
  .catch(err => console.error('Erro ao conectar ao PostgreSQL:', err));

// Rotas
app.get('/', (req, res) => {
  res.send('API funcionando!');
});

// Atletas
app.post('/atletas', async (req, res) => {
  try {
    const atleta = await db.Atleta.create(req.body);
    res.status(201).json(atleta);
  } catch (error) {
    console.error('Erro ao criar atleta:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/atletas', async (req, res) => {
  try {
    const atletas = await db.Atleta.findAll();
    res.status(200).json(atletas);
  } catch (error) {
    console.error('Erro ao buscar atletas:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/atletas/:id', async (req, res) => {
  try {
    const atleta = await db.Atleta.findByPk(req.params.id);
    if (atleta) {
      res.status(200).json(atleta);
    } else {
      res.status(404).json({ error: 'Atleta não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao buscar atleta:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/atletas/:id', async (req, res) => {
  try {
    const [updated] = await db.Atleta.update(req.body, {
      where: { ID_ATLETA: req.params.id }
    });
    if (updated) {
      const updatedAtleta = await db.Atleta.findByPk(req.params.id);
      res.status(200).json(updatedAtleta);
    } else {
      res.status(404).json({ error: 'Atleta não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao atualizar atleta:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/atletas/:id', async (req, res) => {
  try {
    const deleted = await db.Atleta.destroy({
      where: { ID_ATLETA: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Atleta não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao deletar atleta:', error);
    res.status(500).json({ error: error.message });
  }
});

// Times
app.post('/times', async (req, res) => {
  try {
    const time = await db.Time.create(req.body);
    res.status(201).json(time);
  } catch (error) {
    console.error('Erro ao criar time:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/times', async (req, res) => {
  try {
    const times = await db.Time.findAll();
    res.status(200).json(times);
  } catch (error) {
    console.error('Erro ao buscar times:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/times/:id', async (req, res) => {
  try {
    const time = await db.Time.findByPk(req.params.id);
    if (time) {
      res.status(200).json(time);
    } else {
      res.status(404).json({ error: 'Time não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao buscar time:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/times/:id', async (req, res) => {
  try {
    const [updated] = await db.Time.update(req.body, {
      where: { ID_TIME: req.params.id }
    });
    if (updated) {
      const updatedTime = await db.Time.findByPk(req.params.id);
      res.status(200).json(updatedTime);
    } else {
      res.status(404).json({ error: 'Time não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao atualizar time:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/times/:id', async (req, res) => {
  try {
    const deleted = await db.Time.destroy({
      where: { ID_TIME: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Time não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao deletar time:', error);
    res.status(500).json({ error: error.message });
  }
});

// Formação
app.post('/formacoes', async (req, res) => {
  try {
    const formacao = await db.Formacao.create(req.body);
    res.status(201).json(formacao);
  } catch (error) {
    console.error('Erro ao criar formação:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/formacoes', async (req, res) => {
  try {
    const formacoes = await db.Formacao.findAll();
    res.status(200).json(formacoes);
  } catch (error) {
    console.error('Erro ao buscar formações:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/formacoes/:id', async (req, res) => {
  try {
    const formacao = await db.Formacao.findByPk(req.params.id);
    if (formacao) {
      res.status(200).json(formacao);
    } else {
      res.status(404).json({ error: 'Formação não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao buscar formação:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/formacoes/:id', async (req, res) => {
  try {
    const [updated] = await db.Formacao.update(req.body, {
      where: { ID_FORMACAO: req.params.id }
    });
    if (updated) {
      const updatedFormacao = await db.Formacao.findByPk(req.params.id);
      res.status(200).json(updatedFormacao);
    } else {
      res.status(404).json({ error: 'Formação não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao atualizar formação:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/formacoes/:id', async (req, res) => {
  try {
    const deleted = await db.Formacao.destroy({
      where: { ID_FORMACAO: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Formação não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao deletar formação:', error);
    res.status(500).json({ error: error.message });
  }
});

// Notificações
app.post('/notificacoes', async (req, res) => {
  try {
    const notificacao = await db.Notificacao.create(req.body);
    res.status(201).json(notificacao);
  } catch (error) {
    console.error('Erro ao criar notificação:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/notificacoes', async (req, res) => {
  try {
    const notificacoes = await db.Notificacao.findAll();
    res.status(200).json(notificacoes);
  } catch (error) {
    console.error('Erro ao buscar notificações:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/notificacoes/:id', async (req, res) => {
  try {
    const notificacao = await db.Notificacao.findByPk(req.params.id);
    if (notificacao) {
      res.status(200).json(notificacao);
    } else {
      res.status(404).json({ error: 'Notificação não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao buscar notificação:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/notificacoes/:id', async (req, res) => {
  try {
    const [updated] = await db.Notificacao.update(req.body, {
      where: { ID_NOTIFICACAO: req.params.id }
    });
    if (updated) {
      const updatedNotificacao = await db.Notificacao.findByPk(req.params.id);
      res.status(200).json(updatedNotificacao);
    } else {
      res.status(404).json({ error: 'Notificação não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao atualizar notificação:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/notificacoes/:id', async (req, res) => {
  try {
    const deleted = await db.Notificacao.destroy({
      where: { ID_NOTIFICACAO: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Notificação não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao deletar notificação:', error);
    res.status(500).json({ error: error.message });
  }
});

// Partidas
app.post('/partidas', async (req, res) => {
  try {
    const partida = await db.Partida.create(req.body);
    res.status(201).json(partida);
  } catch (error) {
    console.error('Erro ao criar partida:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/partidas', async (req, res) => {
  try {
    const partidas = await db.Partida.findAll();
    res.status(200).json(partidas);
  } catch (error) {
    console.error('Erro ao buscar partidas:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/partidas/:id', async (req, res) => {
  try {
    const partida = await db.Partida.findByPk(req.params.id);
    if (partida) {
      res.status(200).json(partida);
    } else {
      res.status(404).json({ error: 'Partida não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao buscar partida:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/partidas/:id', async (req, res) => {
  try {
    const [updated] = await db.Partida.update(req.body, {
      where: { ID_PARTIDA: req.params.id }
    });
    if (updated) {
      const updatedPartida = await db.Partida.findByPk(req.params.id);
      res.status(200).json(updatedPartida);
    } else {
      res.status(404).json({ error: 'Partida não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao atualizar partida:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/partidas/:id', async (req, res) => {
  try {
    const deleted = await db.Partida.destroy({
      where: { ID_PARTIDA: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Partida não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao deletar partida:', error);
    res.status(500).json({ error: error.message });
  }
});

// Relatórios
app.post('/relatorios', async (req, res) => {
  try {
    const relatorio = await db.Relatorio.create(req.body);
    res.status(201).json(relatorio);
  } catch (error) {
    console.error('Erro ao criar relatório:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/relatorios', async (req, res) => {
  try {
    const relatorios = await db.Relatorio.findAll();
    res.status(200).json(relatorios);
  } catch (error) {
    console.error('Erro ao buscar relatórios:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/relatorios/:id', async (req, res) => {
  try {
    const relatorio = await db.Relatorio.findByPk(req.params.id);
    if (relatorio) {
      res.status(200).json(relatorio);
    } else {
      res.status(404).json({ error: 'Relatório não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao buscar relatório:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/relatorios/:id', async (req, res) => {
  try {
    const [updated] = await db.Relatorio.update(req.body, {
      where: { ID_RELATORIO: req.params.id }
    });
    if (updated) {
      const updatedRelatorio = await db.Relatorio.findByPk(req.params.id);
      res.status(200).json(updatedRelatorio);
    } else {
      res.status(404).json({ error: 'Relatório não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao atualizar relatório:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/relatorios/:id', async (req, res) => {
  try {
    const deleted = await db.Relatorio.destroy({
      where: { ID_RELATORIO: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Relatório não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao deletar relatório:', error);
    res.status(500).json({ error: error.message });
  }
});

// Scout Atleta
app.post('/scout-atletas', async (req, res) => {
  try {
    const scoutAtleta = await db.ScoutAtleta.create(req.body);
    res.status(201).json(scoutAtleta);
  } catch (error) {
    console.error('Erro ao criar scout atleta:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/scout-atletas', async (req, res) => {
  try {
    const scoutAtletas = await db.ScoutAtleta.findAll();
    res.status(200).json(scoutAtletas);
  } catch (error) {
    console.error('Erro ao buscar scout atletas:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/scout-atletas/:id', async (req, res) => {
  try {
    const scoutAtleta = await db.ScoutAtleta.findByPk(req.params.id);
    if (scoutAtleta) {
      res.status(200).json(scoutAtleta);
    } else {
      res.status(404).json({ error: 'Scout Atleta não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao buscar scout atleta:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/scout-atletas/:id', async (req, res) => {
  try {
    const [updated] = await db.ScoutAtleta.update(req.body, {
      where: { ID_SCOUT_ATLETA: req.params.id }
    });
    if (updated) {
      const updatedScoutAtleta = await db.ScoutAtleta.findByPk(req.params.id);
      res.status(200).json(updatedScoutAtleta);
    } else {
      res.status(404).json({ error: 'Scout Atleta não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao atualizar scout atleta:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/scout-atletas/:id', async (req, res) => {
  try {
    const deleted = await db.ScoutAtleta.destroy({
      where: { ID_SCOUT_ATLETA: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Scout Atleta não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao deletar scout atleta:', error);
    res.status(500).json({ error: error.message });
  }
});

// Equipa Sombra
app.post('/equipas-sombra', async (req, res) => {
  try {
    const equipaSombra = await db.EquipaSombra.create(req.body);
    res.status(201).json(equipaSombra);
  } catch (error) {
    console.error('Erro ao criar equipa sombra:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/equipas-sombra', async (req, res) => {
  try {
    const equipasSombra = await db.EquipaSombra.findAll();
    res.status(200).json(equipasSombra);
  } catch (error) {
    console.error('Erro ao buscar equipas sombra:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/equipas-sombra/:id', async (req, res) => {
  try {
    const equipaSombra = await db.EquipaSombra.findByPk(req.params.id);
    if (equipaSombra) {
      res.status(200).json(equipaSombra);
    } else {
      res.status(404).json({ error: 'Equipa Sombra não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao buscar equipa sombra:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/equipas-sombra/:id', async (req, res) => {
  try {
    const [updated] = await db.EquipaSombra.update(req.body, {
      where: { ID_EQUIPA_SOMBRA: req.params.id }
    });
    if (updated) {
      const updatedEquipaSombra = await db.EquipaSombra.findByPk(req.params.id);
      res.status(200).json(updatedEquipaSombra);
    } else {
      res.status(404).json({ error: 'Equipa Sombra não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao atualizar equipa sombra:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/equipas-sombra/:id', async (req, res) => {
  try {
    const deleted = await db.EquipaSombra.destroy({
      where: { ID_EQUIPA_SOMBRA: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Equipa Sombra não encontrada' });
    }
  } catch (error) {
    console.error('Erro ao deletar equipa sombra:', error);
    res.status(500).json({ error: error.message });
  }
});

// Atleta Equipa Sombra
app.post('/atletas-equipas-sombra', async (req, res) => {
  try {
    const atletaEquipaSombra = await db.AtletaEquipaSombra.create(req.body);
    res.status(201).json(atletaEquipaSombra);
  } catch (error) {
    console.error('Erro ao criar atleta equipa sombra:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/atletas-equipas-sombra', async (req, res) => {
  try {
    const atletasEquipasSombra = await db.AtletaEquipaSombra.findAll();
    res.status(200).json(atletasEquipasSombra);
  } catch (error) {
    console.error('Erro ao buscar atletas equipas sombra:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/atletas-equipas-sombra/:id', async (req, res) => {
  try {
    const atletaEquipaSombra = await db.AtletaEquipaSombra.findByPk(req.params.id);
    if (atletaEquipaSombra) {
      res.status(200).json(atletaEquipaSombra);
    } else {
      res.status(404).json({ error: 'Atleta Equipa Sombra não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao buscar atleta equipa sombra:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/atletas-equipas-sombra/:id', async (req, res) => {
  try {
    const [updated] = await db.AtletaEquipaSombra.update(req.body, {
      where: { ID_ATLETA_EQUIPA_SOMBRA: req.params.id }
    });
    if (updated) {
      const updatedAtletaEquipaSombra = await db.AtletaEquipaSombra.findByPk(req.params.id);
      res.status(200).json(updatedAtletaEquipaSombra);
    } else {
      res.status(404).json({ error: 'Atleta Equipa Sombra não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao atualizar atleta equipa sombra:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/atletas-equipas-sombra/:id', async (req, res) => {
  try {
    const deleted = await db.AtletaEquipaSombra.destroy({
      where: { ID_ATLETA_EQUIPA_SOMBRA: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Atleta Equipa Sombra não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao deletar atleta equipa sombra:', error);
    res.status(500).json({ error: error.message });
  }
});

// Utilizadores
app.post('/utilizadores', async (req, res) => {
  try {
    const utilizador = await db.Utilizador.create(req.body);
    res.status(201).json(utilizador);
  } catch (error) {
    console.error('Erro ao criar utilizador:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/utilizadores', async (req, res) => {
  try {
    const utilizadores = await db.Utilizador.findAll();
    res.status(200).json(utilizadores);
  } catch (error) {
    console.error('Erro ao buscar utilizadores:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/utilizadores/:id', async (req, res) => {
  try {
    const utilizador = await db.Utilizador.findByPk(req.params.id);
    if (utilizador) {
      res.status(200).json(utilizador);
    } else {
      res.status(404).json({ error: 'Utilizador não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao buscar utilizador:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/utilizadores/:id', async (req, res) => {
  try {
    const [updated] = await db.Utilizador.update(req.body, {
      where: { ID_UTILIZADOR: req.params.id }
    });
    if (updated) {
      const updatedUtilizador = await db.Utilizador.findByPk(req.params.id);
      res.status(200).json(updatedUtilizador);
    } else {
      res.status(404).json({ error: 'Utilizador não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao atualizar utilizador:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/utilizadores/:id', async (req, res) => {
  try {
    const deleted = await db.Utilizador.destroy({
      where: { ID_UTILIZADOR: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Utilizador não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao deletar utilizador:', error);
    res.status(500).json({ error: error.message });
  }
});

// Website
app.post('/website', async (req, res) => {
  try {
    const website = await db.Website.create(req.body);
    res.status(201).json(website);
  } catch (error) {
    console.error('Erro ao criar website:', error);
    res.status(400).json({ error: error.message });
  }
});

app.get('/website', async (req, res) => {
  try {
    const website = await db.Website.findAll();
    res.status(200).json(website);
  } catch (error) {
    console.error('Erro ao buscar website:', error);
    res.status(500).json({ error: error.message });
  }
});

app.get('/website/:id', async (req, res) => {
  try {
    const website = await db.Website.findByPk(req.params.id);
    if (website) {
      res.status(200).json(website);
    } else {
      res.status(404).json({ error: 'Website não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao buscar website:', error);
    res.status(500).json({ error: error.message });
  }
});

app.put('/website/:id', async (req, res) => {
  try {
    const [updated] = await db.Website.update(req.body, {
      where: { ID_WEBSITE: req.params.id }
    });
    if (updated) {
      const updatedWebsite = await db.Website.findByPk(req.params.id);
      res.status(200).json(updatedWebsite);
    } else {
      res.status(404).json({ error: 'Website não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao atualizar website:', error);
    res.status(400).json({ error: error.message });
  }
});

app.delete('/website/:id', async (req, res) => {
  try {
    const deleted = await db.Website.destroy({
      where: { ID_WEBSITE: req.params.id }
    });
    if (deleted) {
      res.status(204).send();
    } else {
      res.status(404).json({ error: 'Website não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao deletar website:', error);
    res.status(500).json({ error: error.message });
  }
});

// Iniciar o servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
