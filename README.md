# plugin-ice-stark

[![NPM version](https://img.shields.io/npm/v/plugin-ice-stark.svg?style=flat)](https://www.npmjs.com/package/@hexagrams/plugin-ice-stark)
[![NPM downloads](http://img.shields.io/npm/dm/plugin-ice-stark.svg?style=flat)](https://www.npmjs.com/package/@hexagrams/plugin-ice-stark)

UmiJS 微前端插件: https://umijs.org/
ICESTARK: https://micro-frontends.ice.work/

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

## Usage

Configure in `.umirc.js`,

```js
export default {
  plugins: [["@hexagrams/plugin-ice-stark"]],
  // 子应用配置加iceStark:{ slave: {}} 配置
  iceStark: {
    slave: {},
  },
  // 父应用配置 加 iceStark:{master: {}} 配置
  iceStark: {
    master: {},
  },
};
```

## 动态配置 src/app.ts

```js
// 文档 https://micro-frontends.ice.work/docs/api/ice-stark
export const iceStark = fetch("/xxx/xxx")
  .then((res) => res.json())
  .then(({ data }) => {
    return {
      apps: [
        {
          appRouter: {
            onAppEnter: (appConfig) => {
              console.log(appConfig, "appConfigappConfig");
            },
          },
          publicPath: "/", // 非必填子应用资源路径 https://v3.umijs.org/zh-CN/config#publicpath
          name: "microApp",
          activePath: "/seller",
          url: ["//unpkg.com/icestark-child-common/build/js/index.js"],
        },
      ],
    };
  });
```

## 发布

npm publish --access public
