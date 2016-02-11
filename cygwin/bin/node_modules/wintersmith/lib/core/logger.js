
/* logger.coffee */

(function() {
  var chalk, cli, logger, transports, util, winston,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  chalk = require('chalk');

  winston = require('winston');

  util = require('util');

  cli = (function(superClass) {
    extend(cli, superClass);


    /* Winston transport that logs info to stdout and errors stderr */

    cli.prototype.name = 'cli';

    function cli(options) {
      cli.__super__.constructor.call(this, options);
      this.quiet = options.quiet || false;
    }

    cli.prototype.log = function(level, msg, meta, callback) {
      var c, key, pval, stack, value;
      if (level === 'error') {
        process.stderr.write("\n  " + (chalk.red('error')) + " " + msg + "\n");
        if (this.level === 'verbose' && (meta != null)) {
          if (meta.stack != null) {
            stack = meta.stack.substr(meta.stack.indexOf('\n') + 1);
            process.stderr.write(stack + "\n\n");
          }
          for (key in meta) {
            value = meta[key];
            if (key === 'message' || key === 'stack') {
              continue;
            }
            pval = util.inspect(value, false, 2, true).replace(/\n/g, '\n    ');
            process.stderr.write("    " + key + ": " + pval + "\n");
          }
        } else {
          process.stderr.write("\n");
        }
      } else if (!this.quiet) {
        if (level !== 'info') {
          c = level === 'warn' ? 'yellow' : 'grey';
          msg = (chalk[c](level)) + " " + msg;
        }
        if (Object.keys(meta).length > 0) {
          msg += util.format(' %j', meta);
        }
        process.stdout.write("  " + msg + "\n");
      }
      this.emit('logged');
      return callback(null, true);
    };

    return cli;

  })(winston.Transport);

  transports = [
    new cli({
      level: 'info'
    })
  ];

  logger = new winston.Logger({
    exitOnError: true,
    transports: transports
  });

  module.exports = {
    logger: logger,
    transports: transports
  };

}).call(this);
