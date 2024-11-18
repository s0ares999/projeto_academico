// models/associations.js

// Função para definir associações
const defineAssociations = (models) => {
  Object.keys(models).forEach(modelName => {
    // Verifica se o modelo possui uma função `associate`
    if (typeof models[modelName].associate === 'function') {
      models[modelName].associate(models);
    }
  });
};

// Exportando a função para definir as associações entre os modelos
module.exports = defineAssociations;
