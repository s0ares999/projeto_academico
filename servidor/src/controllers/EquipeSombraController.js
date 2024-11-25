// src/controllers/EquipeSombraController.js
const EquipeSombra = require('../models/EquipeSombra');
const Formacao = require('../models/Formacao');

// Criar uma nova equipe sombra

// Criar uma nova equipe sombra
exports.createEquipeSombra = async (req, res) => {
    const { nome, descricao, categoria, formacaoNome } = req.body;
    try {
        // Buscar a formação pelo nome
        const formacao = await Formacao.findOne({ where: { nome: formacaoNome } });
        
        if (!formacao) {
            return res.status(404).json({ error: 'Formação não encontrada' });
        }

        // Criar a nova equipe sombra
        const novaEquipe = await EquipeSombra.create({
            nome,
            descricao,
            categoria,
            formacaoId: formacao.id // Usa o ID da formação encontrada
        });
        
        res.status(201).json(novaEquipe);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao criar equipe sombra' });
    }
};

// Mostrar todas as equipes sombra
exports.getAllEquipesSombra = async (req, res) => {
    try {
        const equipesSombra = await EquipeSombra.findAll({ include: Formacao });
        res.json(equipesSombra);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar equipes sombra' });
    }
};
