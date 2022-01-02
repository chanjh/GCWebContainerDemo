export default function register(name, fn) {
  const { global } = window.gc._config;
  const host = window[global].bridge;
  host[name] = fn;
}