// src/routes/atletasEquipeSombraRoutes.js
const express = require('express');
const router = express.Router();
const atletasEquipeSombraController = require('../controllers/AtletasEquipeSombraController');

// Rota para criar uma nova associação
router.post('/', atletasEquipeSombraController.createAtletaEquipeSombra);

// Rota para listar todas as associações
router.get('/', atletasEquipeSombraController.getAllAtletasEquipeSombra);

// Rota para deletar uma associação
router.delete('/:id', atletasEquipeSombraController.deleteAtletaEquipeSombra);

module.exports = router;
