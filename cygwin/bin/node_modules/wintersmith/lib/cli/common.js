(function() {
  var Config, Environment, NpmAdapter, async, defaults, fileExists, logger, path, readJSON, ref, stream,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  path = require('path');

  async = require('async');

  stream = require('stream');

  Config = require('./../core/config').Config;

  Environment = require('./../core/environment').Environment;

  logger = require('./../core/logger').logger;

  ref = require('./../core/utils'), readJSON = ref.readJSON, fileExists = ref.fileExists;

  exports.commonOptions = defaults = {
    string: ['chdir', 'config', 'contents', 'templates', 'locals', 'require', 'plugins', 'ignore'],
    "default": {
      config: './config.json',
      chdir: null
    },
    alias: {
      config: 'c',
      chdir: 'C',
      contents: 'i',
      templates: 't',
      locals: 'L',
      require: 'R',
      plugins: 'P',
      ignore: 'I'
    }
  };

  exports.commonUsage = ["-C, --chdir [path]            change the working directory", "  -c, --config [path]           path to config (defaults to " + defaults["default"].config + ")", "  -i, --contents [path]         contents location (defaults to " + Config.defaults.contents + ")", "  -t, --templates [path]        template location (defaults to " + Config.defaults.templates + ")", "  -L, --locals [path]           optional path to json file containing template context data", "  -R, --require                 comma separated list of modules to add to the template context", "  -P, --plugins                 comma separated list of modules to load as plugins", "  -I, --ignore                  comma separated list of files/glob-patterns to ignore"].join('\n');

  exports.extendOptions = function(base, extra) {
    var i, j, key, len, len1, ref1, ref2, ref3, type, value;
    ref1 = ['string', 'boolean'];
    for (i = 0, len = ref1.length; i < len; i++) {
      type = ref1[i];
      if (base[type] == null) {
        base[type] = [];
      }
      if (extra[type] != null) {
        base[type] = base[type].concat(extra[type]);
      }
    }
    ref2 = ['alias', 'default'];
    for (j = 0, len1 = ref2.length; j < len1; j++) {
      type = ref2[j];
      if (base[type] == null) {
        base[type] = {};
      }
      if (extra[type] != null) {
        ref3 = extra[type];
        for (key in ref3) {
          value = ref3[key];
          base[type][key] = value;
        }
      }
    }
  };

  exports.loadEnv = function(argv, callback) {

    /* creates a new wintersmith environment
        options are resolved with the hierarchy: argv > configfile > defaults
     */
    var workDir;
    workDir = path.resolve(argv.chdir || process.cwd());
    logger.verbose("creating environment - work directory: " + workDir);
    return async.waterfall([
      function(callback) {
        var configPath;
        configPath = path.join(workDir, argv.config);
        return fileExists(configPath, function(exists) {
          if (exists) {
            logger.info("using config file: " + configPath);
            return Config.fromFile(configPath, callback);
          } else {
            logger.verbose("no config file found");
            return callback(null, new Config);
          }
        });
      }, function(config, callback) {
        var alias, excluded, i, key, len, module, ref1, reqs, v, value;
        config._cliopts = {};
        for (key in argv) {
          value = argv[key];
          excluded = ['_', 'chdir', 'config', 'clean'];
          if (indexOf.call(excluded, key) >= 0) {
            continue;
          }
          if (key === 'port') {
            value = Number(value);
          }
          if (key === 'ignore' || key === 'require' || key === 'plugins') {
            value = value.split(',');
            if (key === 'require') {
              reqs = {};
              for (i = 0, len = value.length; i < len; i++) {
                v = value[i];
                ref1 = v.split(':'), alias = ref1[0], module = ref1[1];
                if (module == null) {
                  module = alias;
                  alias = module.replace(/\/$/, '').split('/').slice(-1);
                }
                reqs[alias] = module;
              }
              value = reqs;
            }
          }
          config[key] = config._cliopts[key] = value;
        }
        return callback(null, config);
      }, function(config, callback) {
        var env;
        logger.verbose('config:', config);
        env = new Environment(config, workDir, logger);
        return callback(null, env);
      }, function(env, callback) {
        var paths;
        paths = ['contents', 'templates'];
        return async.forEach(paths, function(pathname, callback) {
          var resolved;
          resolved = env.resolvePath(env.config[pathname]);
          return fileExists(resolved, function(exists) {
            if (exists) {
              return callback();
            } else {
              return callback(new Error(pathname + " path invalid (" + resolved + ")"));
            }
          });
        }, function(error) {
          return callback(error, env);
        });
      }
    ], callback);
  };

  if (stream.Writable == null) {
    stream.Writable = (function(superClass) {
      extend(Writable, superClass);

      function Writable() {
        Writable.__super__.constructor.call(this);
        this.writable = true;
      }

      Writable.prototype.write = function(string, encodig) {
        if (encodig == null) {
          encodig = 'utf8';
        }
        return this._write(string, encodig, function() {});
      };

      return Writable;

    })(stream.Stream);
  }

  exports.NpmAdapter = NpmAdapter = (function(superClass) {
    extend(NpmAdapter, superClass);


    /* Redirects output of npm to a logger */

    function NpmAdapter(logger1) {
      this.logger = logger1;
      this.buffer = '';
      NpmAdapter.__super__.constructor.call(this, {
        decodeStrings: false
      });
    }

    NpmAdapter.prototype._write = function(chunk, encoding, callback) {
      this.buffer += chunk;
      if (chunk.indexOf('\n') !== -1) {
        this.flush();
      }
      return callback();
    };

    NpmAdapter.prototype.flush = function() {
      var i, len, line, lines, results;
      lines = this.buffer.split('\n');
      this.buffer = '';
      results = [];
      for (i = 0, len = lines.length; i < len; i++) {
        line = lines[i];
        if (!(line.length > 0)) {
          continue;
        }
        line = line.replace(/^npm /, '');
        if (line.slice(0, 4) === 'WARN') {
          results.push(this.logger.warn("npm: " + line.slice(5)));
        } else {
          results.push(this.logger.verbose("npm: " + line));
        }
      }
      return results;
    };

    return NpmAdapter;

  })(stream.Writable);

  exports.getStorageDir = function() {

    /* Return users wintersmith directory, used for cache and user templates. */
    var dir, home;
    if (process.env.WINTERSMITH_PATH != null) {
      return process.env.WINTERSMITH_PATH;
    }
    home = process.env.HOME || process.env.USERPROFILE;
    dir = 'wintersmith';
    if (process.platform !== 'win32') {
      dir = '.' + dir;
    }
    return path.resolve(home, dir);
  };

}).call(this);
