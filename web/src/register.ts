export default function register(name: string, fn: any) {
  const { global } = window.gc._config;
  const host = (window as any)[global].bridge;
  host[name] = fn;
}

