import React from 'react';
// @ts-ignore
import { ApplyPluginsType, plugin } from 'umi';
// @ts-ignore
import { father } from './father';

const masterCfg = {{{masterCfg}}};

async function getMasterRuntime() {
  const config = await plugin.applyPlugins({
    key: 'iceStark',
    type: ApplyPluginsType.modify,
    initialValue: {},
    async: true,
  });
  const { master } = config;
  return Object.assign(masterCfg, master || config);
}

let microAppRuntimeApps;
let appRouterConfog = {};
export function patchRoutes({ routes }) {
  const rootRoute = routes.find((route) => route.path === '/');
  const Layout = rootRoute.component;
  rootRoute.component = () => {
    return React.createElement(
      Layout,
      {
        appRouterConfog,
        microAppRuntimeApps,
      },
      React.createElement(father, {
        appRouterConfog,
        microAppRuntimeApps,
      }),
    );
  };
}

export async function render(oldRender) {
  const runtimeOptions = await getMasterRuntime();
  microAppRuntimeApps = runtimeOptions?.apps;
  appRouterConfog = runtimeOptions?.appRouter;
  oldRender();
}
