(function() {
  var async, build, chalk, commonOptions, commonUsage, extendOptions, fileExistsSync, fs, loadEnv, logger, options, path, ref, rimraf, usage;

  async = require('async');

  chalk = require('chalk');

  fs = require('fs');

  path = require('path');

  rimraf = require('rimraf');

  fileExistsSync = require('./../core/utils').fileExistsSync;

  ref = require('./common'), loadEnv = ref.loadEnv, commonOptions = ref.commonOptions, commonUsage = ref.commonUsage, extendOptions = ref.extendOptions;

  logger = require('./../core/logger').logger;

  usage = "\nusage: wintersmith build [options]\n\noptions:\n\n  -o, --output [path]           directory to write build-output (defaults to ./build)\n  -X, --clean                   clean before building (warning: will recursively delete everything at output path)\n  " + commonUsage + "\n\n  all options can also be set in the config file\n\nexamples:\n\n  build using a config file (assuming config.json is found in working directory):\n  $ wintersmith build\n\n  build using command line options:\n  $ wintersmith build -o /var/www/public/ -T extra_data.json -C ~/my-blog\n\n  or using both (command-line options will override config options):\n  $ wintersmith build --config another_config.json --clean\n";

  options = {
    alias: {
      output: 'o',
      clean: 'X'
    },
    boolean: ['clean'],
    string: ['output']
  };

  extendOptions(options, commonOptions);

  build = function(argv) {
    var prepareOutputDir, start;
    start = new Date();
    logger.info('building site');
    prepareOutputDir = function(env, callback) {
      var exists, outputDir;
      outputDir = env.resolvePath(env.config.output);
      exists = fileExistsSync(outputDir);
      if (exists) {
        if (argv.clean) {
          logger.verbose("cleaning - running rimraf on " + outputDir);
          return async.series([
            function(callback) {
              return rimraf(outputDir, callback);
            }, function(callback) {
              return fs.mkdir(outputDir, callback);
            }
          ], callback);
        } else {
          return callback();
        }
      } else {
        logger.verbose("creating output directory " + outputDir);
        return fs.mkdir(outputDir, callback);
      }
    };
    return async.waterfall([
      function(callback) {
        return loadEnv(argv, callback);
      }, function(env, callback) {
        return prepareOutputDir(env, function(error) {
          return callback(error, env);
        });
      }, function(env, callback) {
        return env.build(callback);
      }
    ], function(error) {
      var delta, stop;
      if (error) {
        logger.error(error.message, error);
        return process.exit(1);
      } else {
        stop = new Date();
        delta = stop - start;
        logger.info("done in " + (chalk.bold(delta)) + " ms\n");
        return process.exit();
      }
    });
  };

  module.exports = build;

  module.exports.usage = usage;

  module.exports.options = options;

}).call(this);
