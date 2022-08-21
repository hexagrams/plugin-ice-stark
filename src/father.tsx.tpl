import React, { useEffect } from 'react';
import { AppRouter, AppRoute, AppConfig } from '@ice/stark';
import { AppRouteProps } from '@ice/stark/lib/AppRoute';

const hashType = {{{hashType}}};

interface AppRouteConfig extends AppConfig {
  publicPath?: string;
}
export interface FatherProps {
  appRouterConfog: AppRouteProps;
  appRouteConfig: AppRouteConfig;
}
export const father = (props: FatherProps) => {
  const { appRouterConfog, appRouteConfig } = props;
  appRouteConfig.hashType = !!hashType;
  useEffect(() => {
    window['publicPath'] = appRouteConfig?.publicPath || '/';
  }, []);
  return (
    <AppRouter {...appRouterConfog}>
      <AppRoute
        {...appRouteConfig}
        props={appRouteConfig}
      ></AppRoute>
    </AppRouter>
  );
};
