const Utilizadores = require('../models/Utilizadores');
const bcrypt = require('bcrypt');

// Criar um novo utilizador
exports.createUtilizador = async (req, res) => {
    const { nome, email, senha, role } = req.body;

    try {
        // Verificar se o email já está em uso
        const emailExistente = await Utilizadores.findOne({ where: { email } });
        if (emailExistente) {
            return res.status(400).json({ error: 'Email já está em uso' });
        }

        // Hash da senha
        const senhaHash = await bcrypt.hash(senha, 10);
        const novoUtilizador = await Utilizadores.create({ nome, email, senha: senhaHash, role });
        res.status(201).json(novoUtilizador);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao criar utilizador' });
    }
};

// Mostrar todos os utilizadores
exports.getAllUtilizadores = async (req, res) => {
    try {
        const utilizadores = await Utilizadores.findAll();
        res.json(utilizadores);
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar utilizadores' });
    }
};

// Mostrar um utilizador pelo ID
exports.getUtilizadorById = async (req, res) => {
    const { id } = req.params;
    try {
        const utilizador = await Utilizadores.findByPk(id);
        if (utilizador) {
            res.json(utilizador);
        } else {
            res.status(404).json({ error: 'Utilizador não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao buscar utilizador' });
    }
};

// Editar um utilizador
exports.updateUtilizador = async (req, res) => {
    const { id } = req.params;
    const { nome, email, senha, role } = req.body;
    try {
        const utilizador = await Utilizadores.findByPk(id);
        if (utilizador) {
            // Atualiza os campos
            utilizador.nome = nome;
            utilizador.email = email;

            // Hash da nova senha, se fornecida
            if (senha) {
                utilizador.senha = await bcrypt.hash(senha, 10);
            }
            
            utilizador.role = role;
            await utilizador.save();
            res.json(utilizador);
        } else {
            res.status(404).json({ error: 'Utilizador não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao atualizar utilizador' });
    }
};

// Apagar um utilizador
exports.deleteUtilizador = async (req, res) => {
    const { id } = req.params;
    try {
        const utilizador = await Utilizadores.findByPk(id);
        if (utilizador) {
            await utilizador.destroy();
            res.status(204).send(); // Status 204 No Content
        } else {
            res.status(404).json({ error: 'Utilizador não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao apagar utilizador' });
    }
};

// Aprovar um utilizador
exports.approveUtilizador = async (req, res) => {
    const { id } = req.params;
    try {
        const utilizador = await Utilizadores.findByPk(id);
        if (utilizador) {
            utilizador.status = 'aprovado'; // Atualiza o status para "aprovado"
            await utilizador.save();
            res.json(utilizador);
        } else {
            res.status(404).json({ error: 'Utilizador não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao aprovar utilizador' });
    }
};

// Rejeitar um utilizador
exports.rejectUtilizador = async (req, res) => {
    const { id } = req.params;
    try {
        const utilizador = await Utilizadores.findByPk(id);
        if (utilizador) {
            utilizador.status = 'rejeitado'; // Atualiza o status para "rejeitado"
            await utilizador.save();
            res.json(utilizador);
        } else {
            res.status(404).json({ error: 'Utilizador não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao rejeitar utilizador' });
    }
};

// Desativar um utilizador
exports.deactivateUtilizador = async (req, res) => {
    const { id } = req.params;
    try {
        const utilizador = await Utilizadores.findByPk(id);
        if (utilizador) {
            utilizador.status = 'desativado'; // Atualiza o status para "desativado"
            await utilizador.save();
            res.json(utilizador);
        } else {
            res.status(404).json({ error: 'Utilizador não encontrado' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao desativar utilizador' });
    }
};
