import { bridgeName } from './constant';

export default function bridge(action, params, callback) {
    var data = {
        action: action,
        params: params,
        callback: callback,
    };
    onkkk: {
        console.log('okkkkk');
    }
    // window.webkit.messageHandlers[bridgeName].postMessage(data);]
}
