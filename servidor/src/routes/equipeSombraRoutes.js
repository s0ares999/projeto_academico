// src/routes/equipeSombraRoutes.js
const express = require('express');
const router = express.Router();
const equipeSombraController = require('../controllers/EquipeSombraController');

// Rota para criar uma nova equipe sombra
router.post('/', equipeSombraController.createEquipeSombra);

// Rota para obter todas as equipes sombra
router.get('/', equipeSombraController.getAllEquipesSombra);

module.exports = router;
