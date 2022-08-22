import { join } from 'path';
import { readFileSync } from 'fs';
import { IApi, utils } from 'umi';

const PLGGIN_NAME = 'plugin-ice-stark';

export function isMasterEnable(api: IApi) {
  const masterCfg = api.userConfig?.iceStark?.master;
  if (masterCfg) {
    return masterCfg.enable !== false;
  }
  return !!process.env.INITIAL_ICESTARK_MASTER_OPTIONS;
}

export function isSlaveEnable(api: IApi) {
  const slaveCfg = api.userConfig?.iceStark?.slave;
  if (slaveCfg) {
    return slaveCfg.enable !== false;
  }
  return !!process.env.INITIAL_ICESTARK_SLAVE_OPTIONS;
}

export default (api: IApi) => {
  // TODO:
  api.describe({
    key: 'iceStark',
    config: {
      schema(joi) {
        return joi.object().keys({
          slave: joi.object(),
          master: joi.object(),
        });
      },
    },
  });
  /** 运行时插件 */
  api.addRuntimePluginKey(() => 'iceStark');
  if (isMasterEnable(api)) {
    api.addRuntimePlugin(() => `@@/${PLGGIN_NAME}/fatherRuntime`);
    api.onGenerateFiles(() => {
      const { config } = api;
      const masterHistoryType = config?.history && config?.history?.type;
      api.writeTmpFile({
        path: `${PLGGIN_NAME}/father.tsx`,
        content: utils.Mustache.render(
          readFileSync(join(__dirname, 'father.tsx.tpl'), 'utf-8'),
          {
            hashType: masterHistoryType,
          },
        ),
      });
      api.writeTmpFile({
        path: `${PLGGIN_NAME}/fatherRuntime.ts`,
        content: utils.Mustache.render(
          readFileSync(join(__dirname, 'fatherRuntime.ts.tpl'), 'utf-8'),
          {
            masterCfg: JSON.stringify(api.userConfig?.iceStark?.master || {}),
          },
        ),
      });
    });
  } else if (isSlaveEnable(api)) {
    api.modifyDefaultConfig(memo => {
      return {
        ...memo,
        runtimePublicPath: true,
        runtimeHistory: {},
      };
    });
    api.addRuntimePlugin(() => `@@/${PLGGIN_NAME}/childrenRuntime`);
    api.onGenerateFiles(() => {
      api.writeTmpFile({
        path: `${PLGGIN_NAME}/childrenRuntime.ts`,
        content: utils.Mustache.render(
          readFileSync(join(__dirname, 'childrenRuntime.ts.tpl'), 'utf-8'),
          {},
        ),
      });
    });
  }
};
