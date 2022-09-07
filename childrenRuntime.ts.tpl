import { setCreateHistoryOptions } from 'umi';
import { getBasename, getMountNode, registerAppLeave, registerAppEnter, isInIcestark } from '@ice/stark-app';
import ReactDOM from 'react-dom';

if (isInIcestark()) {
  setCreateHistoryOptions({
    basename: getBasename(),
    type: window['iceStarkHistoryType'],
  });
}

// 防止控制台抱错
registerAppEnter(() => {});

registerAppLeave(() => {
  ReactDOM.unmountComponentAtNode(getMountNode());
});

export function modifyClientRenderOpts(memo: any) {
  return {
    ...memo,
    rootElement: getMountNode('root'),
  };
}
