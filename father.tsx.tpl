import React from 'react';
import { AppRouter, AppRoute, AppConfig } from '@ice/stark';
import { AppRouteProps, CompatibleAppConfig } from '@ice/stark/lib/AppRoute';

const hashType = `{{{hashType}}}`;

interface AppRouteConfig extends AppConfig {
  publicPath?: string;
  hashType?: any;
}
export interface FatherProps {
  appRouterConfog: AppRouteProps;
  microAppRuntimeApps?: AppRouteConfig[];
}
interface CompatibleAppConfigs extends CompatibleAppConfig {
  publicPath?: string;
}

export const father = (props: FatherProps) => {
  const { appRouterConfog = {}, microAppRuntimeApps } = props;
  return (
    <AppRouter
      {...appRouterConfog}
      onAppEnter={(e: CompatibleAppConfigs) => {
        window['iceStarkHistoryType'] = hashType;
        window['publicPath'] = e?.publicPath || '/';
        appRouterConfog?.onAppEnter?.(e);
      }}
    >
      {microAppRuntimeApps?.map(appRouteConfig => {
        return <AppRoute {...appRouteConfig} key={appRouteConfig?.name} hashType={hashType === 'hash'} props={appRouteConfig}></AppRoute>;
      })}
    </AppRouter>
  );
};
