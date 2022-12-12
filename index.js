"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
exports.isMasterEnable = isMasterEnable;
exports.isSlaveEnable = isSlaveEnable;
function _path() {
  const data = require("path");
  _path = function _path() {
    return data;
  };
  return data;
}
function _fs() {
  const data = require("fs");
  _fs = function _fs() {
    return data;
  };
  return data;
}
function _umi() {
  const data = require("umi");
  _umi = function _umi() {
    return data;
  };
  return data;
}
function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); enumerableOnly && (symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; })), keys.push.apply(keys, symbols); } return keys; }
function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = null != arguments[i] ? arguments[i] : {}; i % 2 ? ownKeys(Object(source), !0).forEach(function (key) { _defineProperty(target, key, source[key]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)) : ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } return target; }
function _defineProperty(obj, key, value) { key = _toPropertyKey(key); if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
const PLGGIN_NAME = 'plugin-ice-stark';
function isMasterEnable(api) {
  var _api$userConfig, _api$userConfig$iceSt;
  const masterCfg = (_api$userConfig = api.userConfig) === null || _api$userConfig === void 0 ? void 0 : (_api$userConfig$iceSt = _api$userConfig.iceStark) === null || _api$userConfig$iceSt === void 0 ? void 0 : _api$userConfig$iceSt.master;
  if (masterCfg) {
    return masterCfg.enable !== false;
  }
  return !!process.env.INITIAL_ICESTARK_MASTER_OPTIONS;
}
function isSlaveEnable(api) {
  var _api$userConfig2, _api$userConfig2$iceS;
  const slaveCfg = (_api$userConfig2 = api.userConfig) === null || _api$userConfig2 === void 0 ? void 0 : (_api$userConfig2$iceS = _api$userConfig2.iceStark) === null || _api$userConfig2$iceS === void 0 ? void 0 : _api$userConfig2$iceS.slave;
  if (slaveCfg) {
    return slaveCfg.enable !== false;
  }
  return !!process.env.INITIAL_ICESTARK_SLAVE_OPTIONS;
}
var _default = api => {
  // TODO:
  api.describe({
    key: 'iceStark',
    config: {
      schema(joi) {
        return joi.object().keys({
          slave: joi.object(),
          master: joi.object()
        });
      }
    }
  });
  /** 运行时插件 */
  api.addRuntimePluginKey(() => 'iceStark');
  if (isMasterEnable(api)) {
    api.addRuntimePlugin(() => `@@/${PLGGIN_NAME}/fatherRuntime`);
    api.onGenerateFiles(() => {
      var _config$history, _api$userConfig3, _api$userConfig3$iceS;
      const config = api.config;
      const masterHistoryType = (config === null || config === void 0 ? void 0 : config.history) && (config === null || config === void 0 ? void 0 : (_config$history = config.history) === null || _config$history === void 0 ? void 0 : _config$history.type);
      api.writeTmpFile({
        path: `${PLGGIN_NAME}/father.tsx`,
        content: _umi().utils.Mustache.render((0, _fs().readFileSync)((0, _path().join)(__dirname, 'father.tsx.tpl'), 'utf-8'), {
          hashType: masterHistoryType
        })
      });
      api.writeTmpFile({
        path: `${PLGGIN_NAME}/fatherRuntime.ts`,
        content: _umi().utils.Mustache.render((0, _fs().readFileSync)((0, _path().join)(__dirname, 'fatherRuntime.ts.tpl'), 'utf-8'), {
          masterCfg: JSON.stringify(((_api$userConfig3 = api.userConfig) === null || _api$userConfig3 === void 0 ? void 0 : (_api$userConfig3$iceS = _api$userConfig3.iceStark) === null || _api$userConfig3$iceS === void 0 ? void 0 : _api$userConfig3$iceS.master) || {})
        })
      });
    });
  } else if (isSlaveEnable(api)) {
    api.modifyDefaultConfig(memo => {
      return _objectSpread(_objectSpread({}, memo), {}, {
        runtimePublicPath: true,
        runtimeHistory: {}
      });
    });
    api.addRuntimePlugin(() => `@@/${PLGGIN_NAME}/childrenRuntime`);
    api.onGenerateFiles(() => {
      api.writeTmpFile({
        path: `${PLGGIN_NAME}/childrenRuntime.ts`,
        content: _umi().utils.Mustache.render((0, _fs().readFileSync)((0, _path().join)(__dirname, 'childrenRuntime.ts.tpl'), 'utf-8'), {})
      });
    });
  }
};
exports.default = _default;