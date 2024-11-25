// src/routes/scoutAtletaRoutes.js
const express = require('express');
const router = express.Router();
const scoutAtletaController = require('../controllers/ScoutAtletaController');

// Rota para criar uma nova associação
router.post('/', scoutAtletaController.createScoutAtleta);

// Rota para listar todas as associações
router.get('/', scoutAtletaController.getAllScoutAtletas);

// Rota para remover uma associação
router.delete('/:id', scoutAtletaController.deleteScoutAtleta);

module.exports = router;
