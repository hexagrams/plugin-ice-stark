import { setCreateHistoryOptions } from "umi";
import { getBasename, getMountNode, registerAppLeave } from "@ice/stark-app";
import ReactDOM from "react-dom";

setCreateHistoryOptions({
  basename: getBasename(),
  type: window["iceStarkHistoryType"],
});

registerAppLeave(() => {
  ReactDOM.unmountComponentAtNode(getMountNode());
});

export function modifyClientRenderOpts(memo: any) {
  return {
    ...memo,
    rootElement: getMountNode("root"),
  };
}
