import React from 'react';
// @ts-ignore
import { ApplyPluginsType, plugin, IRouteProps } from 'umi';
// @ts-ignore
import { father } from './father';

async function getMasterRuntime() {
  const config = await plugin.applyPlugins({
    key: 'iceStark',
    type: ApplyPluginsType.modify,
    initialValue: {},
    async: true,
  });
  const { master } = config;
  return master || config;
}

const getRootRoutes = (routes: IRouteProps[]) => {
  const rootRoute = routes.find((route) => route.path === '/');
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
export function patchRoutes({ routes }) {
  if (microAppRuntimeApps) {
    const rootRoutes = getRootRoutes(routes);
    microAppRuntimeApps.forEach((microAppRoute) => {
      const appRouterConfog = microAppRoute.appRouter || {};
      delete microAppRoute.appRouter;
      const appRouteConfig = microAppRoute;
      rootRoutes.push({
        path: microAppRoute.activePath,
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
  oldRender();
}
