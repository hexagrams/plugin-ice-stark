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
    registerAppLeave(() => {
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
