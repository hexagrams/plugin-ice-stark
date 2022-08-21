# plugin-ice-stark

[![NPM version](https://img.shields.io/npm/v/plugin-ice-stark.svg?style=flat)](https://npmjs.org/package/plugin-ice-stark)
[![NPM downloads](http://img.shields.io/npm/dm/plugin-ice-stark.svg?style=flat)](https://npmjs.org/package/plugin-ice-stark)

@ice/stark微前端

## Install

```bash
# or yarn
$ npm install
```

```bash
$ npm run build --watch
$ npm run start
```

## Usage

Configure in `.umirc.js`,

```js
export default {
  plugins: [
    ['@hexagrams/plugin-ice-stark'],
  ],
   // 子应用配置
  iceStark: {
    slave: {},
  },
  // 父应用配置
  iceStark: {
    master: {},
  },
}

```

## 动态配置 src/app.ts
```js 
// 文档 https://micro-frontends.ice.work/docs/api/ice-stark  
export const iceStark = fetch('/xxx/xxx')
  .then((res) => res.json())
  .then(({ data }) => {
    return {
      apps: [
        {
           appRouter: {
            onAppEnter: (appConfig) => {
              console.log(appConfig, 'appConfigappConfig');
            },
          },
          name: 'microApp',
          activePath: '/seller',
          url: ['//unpkg.com/icestark-child-common/build/js/index.js'],
        },
      ],
    };
  });
```


## Options

TODO setCreateHistoryOptions 貌似不生效

## LICENSE

MIT
