const Sequelize = require('sequelize');
const Partida = require('../models/Partida');
const Atleta = require('../models/Atleta');
const Time = require('../models/Time');
const Utilizadores = require('../models/Utilizadores');

module.exports = {
  // Método para criar uma partida
  async criarPartida(req, res) {
    const { data, hora, local, timeMandanteId, timeVisitanteId, jogadoresIds, scoutsIds } = req.body;

    try {
      // Verifica se o time mandante existe
      const timeMandante = await Time.findByPk(timeMandanteId);
      if (!timeMandante) {
        return res.status(400).json({ error: 'Time mandante não encontrado' });
      }

      // Verifica se o time visitante existe (se fornecido)
      let timeVisitante = null; // Usando let para permitir alteração
      if (timeVisitanteId) {
        timeVisitante = await Time.findByPk(timeVisitanteId);
        if (!timeVisitante) {
          return res.status(400).json({ error: 'Time visitante não encontrado' });
        }
      }

      // Cria a partida com ou sem time visitante
      const partida = await Partida.create({
        data,
        hora,
        local,
        timeMandanteId,
        timeVisitanteId: timeVisitanteId || null, // Se timeVisitanteId não for fornecido, utiliza null
      });

      // Adiciona jogadores à partida (opcional)
      if (jogadoresIds && jogadoresIds.length > 0) {
        const jogadores = await Atleta.findAll({
          where: { id: jogadoresIds },
        });
        await partida.addJogadores(jogadores);
      }

      // Adiciona scouts e admins à partida (opcional)
      if (scoutsIds && scoutsIds.length > 0) {
        const scoutsAdmins = await Utilizadores.findAll({
          where: {
            id: scoutsIds,
            [Sequelize.Op.or]: [
              { role: 'Scout' },
              { role: 'Admin' },
            ],
          },
        });

        // Adiciona os scouts e admins à partida
        await partida.addScouts(scoutsAdmins);
      }

      res.status(201).json(partida);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erro ao criar a partida' });
    }
  },

  // Método para listar todas as partidas
  async listarPartidas(req, res) {
    try {
      const partidas = await Partida.findAll({
        include: [
          { model: Time, as: 'timeMandante' },
          { model: Time, as: 'timeVisitante' },
          { model: Atleta, as: 'jogadores' },
          { model: Utilizadores, as: 'scouts' },
        ],
      });

      res.status(200).json(partidas);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erro ao buscar as partidas' });
    }
  },

  // Método para listar a próxima partida
  async listarProximaPartida(req, res) {
    try {
      const partidas = await Partida.findAll({
        include: [
          { model: Time, as: 'timeMandante' },
          { model: Time, as: 'timeVisitante' },
          { model: Atleta, as: 'jogadores' },
          { model: Utilizadores, as: 'scouts' },
        ],
      });

      // Filtra a próxima partida com base na data
      const próximaPartida = partidas
        .map(partida => {
          const partidaData = new Date(partida.data);
          return { ...partida.toJSON(), partidaData };
        })
        .filter(partida => partida.partidaData > new Date()) // Filtra as partidas no futuro
        .sort((a, b) => a.partidaData - b.partidaData) // Ordena por data
        .shift(); // Pega o primeiro jogo (próxima partida)

      if (!próximaPartida) {
        return res.status(404).json({ message: 'Nenhuma partida futura encontrada' });
      }

      res.status(200).json(próximaPartida);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erro ao buscar a próxima partida' });
    }
  },

  // Método para listar as partidas atribuídas ao usuário logado
  async listarPartidasAtribuidas(req, res) {
    const { userId } = req.params; // Recebe o ID do usuário logado como parâmetro

    try {
      // Busca as partidas em que o usuário logado está como scout
      const partidas = await Partida.findAll({
        include: [
          { model: Time, as: 'timeMandante' },
          { model: Time, as: 'timeVisitante' },
          { model: Atleta, as: 'jogadores' },
          { model: Utilizadores, as: 'scouts', where: { id: userId } }, // Filtra pela id do usuário
        ],
      });

      if (partidas.length === 0) {
        return res.status(404).json({ message: 'Nenhuma partida atribuída para o usuário.' });
      }

      res.status(200).json(partidas);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erro ao buscar as partidas atribuídas' });
    }
  },

  // Método para excluir uma partida
  async excluirPartida(req, res) {
    const { partidaId } = req.params; // ID da partida a ser excluída

    try {
      const partida = await Partida.findByPk(partidaId);
      if (!partida) {
        return res.status(404).json({ error: 'Partida não encontrada' });
      }

      // Exclui a partida
      await partida.destroy();

      res.status(200).json({ message: 'Partida excluída com sucesso' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erro ao excluir a partida' });
    }
  },

  // Método para editar uma partida
  async editarPartida(req, res) {
    const { partidaId } = req.params; // ID da partida a ser editada
    const { data, hora, local, timeMandanteId, timeVisitanteId } = req.body;

    try {
      const partida = await Partida.findByPk(partidaId);
      if (!partida) {
        return res.status(404).json({ error: 'Partida não encontrada' });
      }

      // Atualiza a partida
      partida.data = data || partida.data;
      partida.hora = hora || partida.hora;
      partida.local = local || partida.local;
      partida.timeMandanteId = timeMandanteId || partida.timeMandanteId;
      partida.timeVisitanteId = timeVisitanteId || partida.timeVisitanteId;

      await partida.save();

      res.status(200).json(partida);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Erro ao editar a partida' });
    }
  },
};
