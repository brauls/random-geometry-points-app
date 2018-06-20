import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

import ClipboardJS from "clipboard";

const app = Main.embed(document.getElementById("root"));

const clipboard = new ClipboardJS(".btn");

registerServiceWorker();
