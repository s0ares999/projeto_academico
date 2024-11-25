// src/routes/partidaRoutes.js

const express = require('express');
const router = express.Router();
const PartidaController = require('../controllers/partidaController');

// Rota para listar todas as partidas
router.get('/', PartidaController.listarPartidas);

// Rota para listar as partidas atribuídas ao usuário
router.get('/atribuidas/:userId', PartidaController.listarPartidasAtribuidas);

// Rota para criar uma partida
router.post('/', PartidaController.criarPartida);

// Rota para excluir uma partida
router.delete('/:partidaId', PartidaController.excluirPartida);

// Rota para editar uma partida
router.put('/:partidaId', PartidaController.editarPartida);

module.exports = router;
