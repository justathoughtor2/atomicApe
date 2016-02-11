(function() {
  var ContentPlugin, ContentTree, Environment, TemplatePlugin, ref;

  ref = require('./core/content'), ContentTree = ref.ContentTree, ContentPlugin = ref.ContentPlugin;

  Environment = require('./core/environment').Environment;

  TemplatePlugin = require('./core/templates').TemplatePlugin;

  module.exports = function() {
    return Environment.create.apply(null, arguments);
  };

  module.exports.Environment = Environment;

  module.exports.ContentPlugin = ContentPlugin;

  module.exports.ContentTree = ContentTree;

  module.exports.TemplatePlugin = TemplatePlugin;

}).call(this);
