(function() {
  var Config, async, commonOptions, commonUsage, extendOptions, loadEnv, logger, options, preview, ref, usage, util;

  async = require('async');

  util = require('util');

  Config = require('./../core/config').Config;

  logger = require('./../core/logger').logger;

  ref = require('./common'), loadEnv = ref.loadEnv, commonUsage = ref.commonUsage, commonOptions = ref.commonOptions, extendOptions = ref.extendOptions;

  usage = "\nusage: wintersmith preview [options]\n\noptions:\n\n  -p, --port [port]             port to run server on (defaults to " + Config.defaults.port + ")\n  -H, --hostname [host]         host to bind server onto (defaults to INADDR_ANY)\n  " + commonUsage + "\n\n  all options can also be set in the config file\n\nexamples:\n\n  preview using a config file (assuming config.json is found in working directory):\n  $ wintersmith preview\n";

  options = {
    string: ['port', 'hostname'],
    alias: {
      port: 'p',
      hostname: 'H'
    }
  };

  extendOptions(options, commonOptions);

  preview = function(argv) {
    logger.info('starting preview server');
    return async.waterfall([
      function(callback) {
        return loadEnv(argv, callback);
      }, function(env, callback) {
        return env.preview(callback);
      }
    ], function(error) {
      if (error) {
        logger.error(error.message, error);
        return process.exit(1);
      }
    });
  };

  module.exports = preview;

  module.exports.usage = usage;

  module.exports.options = options;

}).call(this);
