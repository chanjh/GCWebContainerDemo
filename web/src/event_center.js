import register from './register';
export default class EventCenter {
  listeners = [];

  subscribe(event, fn) {
    const { listeners } = this;
    let listenersForEvent = listeners[event]
    if (!listenersForEvent) {
      listenersForEvent = []
    }
    listenersForEvent.push(fn);
    listeners[event] = listenersForEvent;
  }

  async publish(event, params) {
    const { listeners } = this;
    const listenersForEvent = listeners[event];
    if (listenersForEvent) {
      for (const listener of listenersForEvent) {
        await listener(params);
      }
    }
  }
}
register('eventCenter', new EventCenter());