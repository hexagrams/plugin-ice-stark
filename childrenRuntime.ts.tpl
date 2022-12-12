import { setCreateHistoryOptions } from 'umi';
import { getBasename, getMountNode, registerAppLeave, registerAppEnter, isInIcestark } from '@ice/stark-app';
import ReactDOM from 'react-dom';

if (isInIcestark()) {
  setCreateHistoryOptions({
    basename: getBasename(),
    type: window['iceStarkHistoryType'],
  });
}

export function render(oldRender) {
  if (isInIcestark()) {
    registerAppEnter(() => {
      oldRender();
    });
    registerAppLeave(({ container }) => {
      // 解决子应用卸载的生命周期丢失问题
      if (container instanceof Element) {
        ReactDOM.unmountComponentAtNode(container);
        return;
      }
      ReactDOM.unmountComponentAtNode(getMountNode());
    });
  } else {
    oldRender();
  }
}

export function modifyClientRenderOpts(memo: any) {
  return {
    ...memo,
    rootElement: getMountNode('root'),
  };
}
