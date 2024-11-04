// models/associations.js
const Atleta = require('./atleta');
const Time = require('./Time');
const Relatorio = require('./relatorio');
const Notificacao = require('./notificacao');
const ScoutAtleta = require('./scoutatleta');
const EquipaSombra = require('./equipasombra');
const AtletaEquipaSombra = require('./atletaequipasombra');

// Definindo as associações
Atleta.belongsTo(Time, { foreignKey: 'ID_TIME' });
Time.hasMany(Atleta, { foreignKey: 'ID_TIME' });

Relatorio.belongsTo(Atleta, { foreignKey: 'ID_ATLETA' });
Atleta.hasMany(Relatorio, { foreignKey: 'ID_ATLETA' });

Notificacao.belongsTo(Utilizador, { foreignKey: 'ID_UTILIZADOR' });
Utilizador.hasMany(Notificacao, { foreignKey: 'ID_UTILIZADOR' });

ScoutAtleta.belongsTo(Utilizador, { foreignKey: 'ID_UTILIZADOR' });
ScoutAtleta.belongsTo(Relatorio, { foreignKey: 'ID_RELATORIO' });

EquipaSombra.hasMany(AtletaEquipaSombra, { foreignKey: 'ID_EQUIPASOMBRA' });
AtletaEquipaSombra.belongsTo(EquipaSombra, { foreignKey: 'ID_EQUIPASOMBRA' });

module.exports = (sequelize) => {
    // Aplicando os modelos para garantir que as associações são válidas
    Atleta.init(sequelize);
    Time.init(sequelize);
    Relatorio.init(sequelize);
    Notificacao.init(sequelize);
    ScoutAtleta.init(sequelize);
    EquipaSombra.init(sequelize);
    AtletaEquipaSombra.init(sequelize);
    Utilizador.init(sequelize);
    Website.init(sequelize);
  };
