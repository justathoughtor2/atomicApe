/*global $, brackets, define*/

define(function (require, exports, module) {
  'use strict';

  // imports
  var CodeInspection = brackets.getModule('language/CodeInspection');
  var ProjectManager = brackets.getModule('project/ProjectManager');
  var ExtensionUtils = brackets.getModule('utils/ExtensionUtils');
  var NodeDomain = brackets.getModule('utils/NodeDomain');

  // constants
  var LINTER_NAME = 'ESLint';
  var nodeDomain = new NodeDomain('zaggino.brackets-eslint', ExtensionUtils.getModulePath(module, 'domain'));

  // this will map ESLint output to match format expected by Brackets
  function remapResults(results, version) {
    return {
      errors: results.map(function (result) {
        var offset = version < 1 ? 0 : 1;
        var message = result.message;
        if (result.ruleId) {
          message += ' [' + result.ruleId + ']';
        }
        return {
          message: message,
          pos: {
            line: result.line - 1,
            ch: result.column - offset
          },
          type: result.ruleId
        };
      })
    };
  }

  function handleLintSync(text, fullPath) {
    throw new Error('ESLint sync is not available, use async for ' + fullPath);
  }

  function handleLintAsync(text, fullPath) {
    var deferred = new $.Deferred();
    var projectRoot = ProjectManager.getProjectRoot().fullPath;

    nodeDomain.exec('lintFile', fullPath, projectRoot)
      .then(function (report) {
        if (report.results.length > 1) {
          //console.warn('ESLint returned multiple results, where only one set was expected');
        }
        var results = report.results[0];
        //if version is missing, assume 1
        var version = report.eslintVersion ? report.eslintVersion.split('.')[0] : 1;
        var remapped = remapResults(results.messages, version);
        deferred.resolve(remapped);
      }, function (err) {
        deferred.reject(err);
      });

    return deferred.promise();
  }

  // register a linter with CodeInspection
  ['javascript', 'jsx'].forEach(function (langId) {
    CodeInspection.register(langId, {
      name: LINTER_NAME,
      scanFile: handleLintSync,
      scanFileAsync: handleLintAsync
    });
  });

});
