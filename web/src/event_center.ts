import register from './register';
export default class EventCenter {
  listeners: { [key: string]: Function[] } = {};

  subscribe(event: string, fn: Function) {
    const { listeners } = this;
    let listenersForEvent = listeners[event]
    if (!listenersForEvent) {
      listenersForEvent = []
    }
    listenersForEvent.push(fn);
    listeners[event] = listenersForEvent;
  }

  publish(event: string, ...params: any[]) {
    const { listeners } = this;
    const listenersForEvent = listeners[event];
    if (listenersForEvent) {
      for (const listener of listenersForEvent) {
        listener(...params);
      }
    }
  }
}
register('eventCenter', new EventCenter());