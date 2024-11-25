// src/controllers/authController.js
const Usuario = require('../models/Utilizadores');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const config = require('../config');

// Função para login de usuário
exports.login = async (req, res) => {
    try {
        const { email, senha } = req.body;
        const usuario = await Usuario.findOne({ where: { email } });

        if (!usuario) {
            return res.status(404).json({ error: 'Usuário não encontrado' });
        }

        // Verifica o status do usuário
        if (usuario.status !== 'aprovado') {
            return res.status(403).json({ error: 'A conta ainda não foi aprovada pelo administrador' });
        }

        // Verifica se a senha está correta
        const senhaValida = await bcrypt.compare(senha, usuario.senha);
        if (!senhaValida) {
            return res.status(401).json({ error: 'Senha incorreta' });
        }

        // Gera token JWT
        const token = jwt.sign({ id: usuario.id, role: usuario.role }, config.jwtSecret, { expiresIn: '1h' });

        // Envia o token e a role do usuário como resposta
        res.json({ message: 'Login realizado com sucesso', token, role: usuario.role, id: usuario.id });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
