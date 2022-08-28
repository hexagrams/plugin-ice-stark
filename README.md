# plugin-ice-stark

[![NPM version](https://img.shields.io/npm/v/plugin-ice-stark.svg?style=flat)](https://www.npmjs.com/package/@hexagrams/plugin-ice-stark)
[![NPM downloads](http://img.shields.io/npm/dm/plugin-ice-stark.svg?style=flat)](https://www.npmjs.com/package/@hexagrams/plugin-ice-stark)

UmiJS：[Umi](https://umijs.org/)
飞冰：[ICESTARK](https://micro-frontends.ice.work/)
DEMO：[个人站](https://linshenglong.cn/)

## 为什么不用 qiankun?

- 乾坤是通过 fetch 去加载 js/css 有跨域问题；
- ICESTARK 动态挂载 script 标签无跨域问题，也支持 fetch 加载 js/css
- ICESTARK 使用简单，轻量

## 注意事项

- 为什么本地加载子应用会一直刷新？ 关闭热更新 "dev": "HMR=none umi dev",

## Install

```bash
# or yarn
$ npm i @hexagrams/plugin-ice-stark -S
```

## 父应用加配置项

Configure in `.umirc.js`,

```js
import { defineConfig } from 'umi';
export default defineConfig({
  plugins: ['@hexagrams/plugin-ice-stark'],
  iceStark: {
    master: {},
  }
});
```

## 子应用加配置项

Configure in `.umirc.js`,

```js
import { defineConfig } from 'umi';
export default defineConfig({
  plugins: ['@hexagrams/plugin-ice-stark'],
  iceStark: {
    slave: {},
  }
});
```

## 父应用动态配置

Configure in `src/app.ts`,

```js
// API文档 https://micro-frontends.ice.work/docs/api/ice-stark
export const iceStark = fetch('/xxx/xxx')
  .then(res => res.json())
  .then(({ data }) => {
    return {
      appRouter: {
        onAppEnter: appConfig => {
          console.log(appConfig, 'appConfigappConfig');
        },
      },
      apps: [
        {
          publicPath: '/', // 非必填子应用资源路径 https://v3.umijs.org/zh-CN/config#publicpath
          name: 'microApp',
          activePath: '/seller',
          url: ['//unpkg.com/icestark-child-common/build/js/index.js'],
        },
      ],
    };
  });

// 或者
export const iceStark = {
  appRouter: {
    onAppEnter: appConfig => {
      console.log(appConfig, 'appConfigappConfig');
    },
  },
  apps: [
    {
      publicPath: '/', // 非必填子应用资源路径 https://v3.umijs.org/zh-CN/config#publicpath
      name: 'microApp',
      activePath: '/seller',
      url: ['//unpkg.com/icestark-child-common/build/js/index.js'],
    },
  ],
};

```

## 发布

npm publish --access public
