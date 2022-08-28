import React from 'react';
// @ts-ignore
import { ApplyPluginsType, plugin, IRouteProps } from 'umi';
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
  return Object.assign(masterCfg, (master || config));
}

const getRootRoutes = (routes: IRouteProps[]) => {
  const rootRoute = routes.find(route => route.path === '/');
  if (rootRoute) {
    // 如果根路由是叶子节点，则直接返回其父节点
    if (!rootRoute.routes) {
      return routes;
    }
    return getRootRoutes(rootRoute.routes);
  }
  return routes;
};

let microAppRuntimeApps;
let appRouterConfog = {};
export function patchRoutes({ routes }) {
  if (microAppRuntimeApps) {
    const rootRoutes = getRootRoutes(routes);
    microAppRuntimeApps.forEach(appRouteConfig => {
      rootRoutes.push({
        path: appRouteConfig.activePath,
        exact: false,
        component: () =>
          React.createElement(father, {
            appRouterConfog,
            appRouteConfig,
          }),
      });
    });
  }
}

export async function render(oldRender) {
  const runtimeOptions = await getMasterRuntime();
  microAppRuntimeApps = runtimeOptions?.apps;
  appRouterConfog = runtimeOptions?.appRouter;
  oldRender();
}
