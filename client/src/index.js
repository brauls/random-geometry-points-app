import "./main.css";
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

import ClipboardJS from "clipboard";

Elm.Main.init({
  node: document.getElementById('root')
});

const clipboard = new ClipboardJS(".btn");

registerServiceWorker();
