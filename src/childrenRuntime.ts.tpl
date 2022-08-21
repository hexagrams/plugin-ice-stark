import { setCreateHistoryOptions } from 'umi';
import {
  registerAppEnter,
  getBasename,
  getMountNode,
  registerAppLeave,
} from '@ice/stark-app';
import ReactDOM from 'react-dom';

window['routerBase'] = getBasename();

registerAppEnter((props) => {
  setCreateHistoryOptions({
    type: props.customProps.hashType ? 'hash' : 'browser',
  });
});

registerAppLeave(() => {
  ReactDOM.unmountComponentAtNode(getMountNode());
});

export function modifyClientRenderOpts(memo: any) {
  return {
    ...memo,
    rootElement: getMountNode('root'),
  };
}
