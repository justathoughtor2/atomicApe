(function() {
  var deprecatedPackages, semver;

  semver = require('npm/node_modules/semver');

  deprecatedPackages = null;

  exports.isDeprecatedPackage = function(name, version) {
    var deprecatedVersionRange, _ref;
    if (deprecatedPackages == null) {
      deprecatedPackages = (_ref = require('../deprecated-packages')) != null ? _ref : {};
    }
    if (!deprecatedPackages.hasOwnProperty(name)) {
      return false;
    }
    deprecatedVersionRange = deprecatedPackages[name].version;
    if (!deprecatedVersionRange) {
      return true;
    }
    return semver.valid(version) && semver.validRange(deprecatedVersionRange) && semver.satisfies(version, deprecatedVersionRange);
  };

}).call(this);
