import React, { useEffect } from 'react';
import { AppRouter, AppRoute, AppConfig } from '@ice/stark';
import { AppRouteProps } from '@ice/stark/lib/AppRoute';

const hashType = `{{{hashType}}}`;

interface AppRouteConfig extends AppConfig {
  publicPath?: string;
  hashType?: any;
}
export interface FatherProps {
  appRouterConfog: AppRouteProps;
  appRouteConfig: AppRouteConfig;
}
export const father = (props: FatherProps) => {
  const { appRouterConfog, appRouteConfig } = props;
  useEffect(() => {
    window['publicPath'] = appRouteConfig?.publicPath || '/';
  }, []);
  appRouteConfig.hashType = hashType;
  return (
    <AppRouter {...appRouterConfog}>
      <AppRoute
        {...appRouteConfig}
        hashType={hashType === 'hash'}
        props={appRouteConfig}
      ></AppRoute>
    </AppRouter>
  );
};
