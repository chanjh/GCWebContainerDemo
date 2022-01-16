
import Global from "./global";

declare global {
  interface Window {
    webkit?: any;
    gc?: Global;
  }
}
