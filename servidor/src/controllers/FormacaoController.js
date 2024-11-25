// src/controllers/FormacaoController.js
const Formacao = require('../models/Formacao');

// Criar uma nova formação
exports.createFormacao = async (req, res) => {
    const { nome } = req.body;
    try {
        const novaFormacao = await Formacao.create({ nome });
        res.status(201).json(novaFormacao);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao criar formação' });
    }
};

// Mostrar todas as formações
exports.getAllFormacoes = async (req, res) => {
    try {
        const formacoes = await Formacao.findAll();
        res.json(formacoes);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar formações' });
    }
};

// Mostrar uma formação pelo ID
exports.getFormacaoById = async (req, res) => {
    const { id } = req.params;
    try {
        const formacao = await Formacao.findByPk(id);
        if (formacao) {
            res.json(formacao);
        } else {
            res.status(404).json({ error: 'Formação não encontrada' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar formação' });
    }
};

// Editar uma formação
exports.updateFormacao = async (req, res) => {
    const { id } = req.params;
    const { nome } = req.body;
    try {
        const formacao = await Formacao.findByPk(id);
        if (formacao) {
            formacao.nome = nome;
            await formacao.save();
            res.json(formacao);
        } else {
            res.status(404).json({ error: 'Formação não encontrada' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao atualizar formação' });
    }
};

// Apagar uma formação
exports.deleteFormacao = async (req, res) => {
    const { id } = req.params;
    try {
        const formacao = await Formacao.findByPk(id);
        if (formacao) {
            await formacao.destroy();
            res.status(204).send(); // Status 204 No Content
        } else {
            res.status(404).json({ error: 'Formação não encontrada' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao apagar formação' });
    }
};
