/**
 * The default options of YASQE (check the CodeMirror documentation for even
 * more options, such as disabling line numbers, or changing keyboard shortcut
 * keys). Either change the default options by setting Yasqe.defaults, or by
 * passing your own options as second argument to the YASQE constructor
 */
import { default as Yasqe, Config } from "./";

//need to pass Yasqe object as argument, as the imported version might not have inherited all (e.g. `fold`) props of Codemirror yet
export default function get() {
  const CodeMirror = require("codemirror");
  const config: Config = {
    mode: "sparql11",
    value: `PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT * WHERE {
  ?sub ?pred ?obj .
} LIMIT 10`,
    highlightSelectionMatches: {
      showToken: /\w/,
    },
    tabMode: "indent",
    lineNumbers: true,
    lineWrapping: true,
    foldGutter: {
      rangeFinder: new (<any>CodeMirror).fold.combine((<any>CodeMirror).fold.brace, (<any>CodeMirror).fold.prefix),
    },
    collapsePrefixesOnLoad: false,
    gutters: ["gutterErrorBar", "CodeMirror-linenumbers", "CodeMirror-foldgutter"],
    matchBrackets: true,
    fixedGutter: true,
    syntaxErrorCheck: true,
    autocompleters: [],
    extraKeys: {
      /**
       * Need to use _yasqe:any as function parameter here. Otherwise ts will complain that we're not following
       * the codemirror config interface (that specifies the type should be codemirror-editor)
       */
      "Ctrl-Space": function (_yasqe: any) {
        const yasqe: Yasqe = _yasqe;
        yasqe.autocomplete();
      },
      "Shift-Ctrl-K": function (_yasqe: any) {
        const yasqe: Yasqe = _yasqe;
        const lineNumber = yasqe.getDoc().getCursor().line;
        if (lineNumber === yasqe.getDoc().lastLine() && lineNumber > 1) {
          //delete current line, and the linebreak just before
          return yasqe
            .getDoc()
            .replaceRange(
              "",
              { ch: yasqe.getDoc().getLine(lineNumber - 1).length, line: lineNumber - 1 },
              { ch: yasqe.getDoc().getLine(lineNumber).length, line: lineNumber }
            );
        } else {
          //delete current line including the linebreak after
          return yasqe.getDoc().replaceRange("", { ch: 0, line: lineNumber }, { ch: 0, line: lineNumber + 1 });
        }
      },
      "Ctrl-/": function (_yasqe: any) {
        const yasqe: Yasqe = _yasqe;
        yasqe.commentLines();
      },
      "Shift-Ctrl-D": function (_yasqe: any) {
        const yasqe: Yasqe = _yasqe;
        yasqe.duplicateLine();
      },
      "Shift-Ctrl-F": function (_yasqe: any) {
        const yasqe: Yasqe = _yasqe;
        yasqe.autoformat();
      },
      "Ctrl-S": function (_yasqe: any) {
        const yasqe: Yasqe = _yasqe;
        yasqe.saveQuery();
      },
      Esc: function (_yasqe: any) {
        const yasqe: Yasqe = _yasqe;
        yasqe.getInputField().blur();
      },
    },

    persistenceId: function (yasqe: Yasqe) {
      //Traverse parents untl we've got an id
      // Get matching parent elements
      let id = "";
      let elem: any = yasqe.rootEl;
      if ((<any>elem).id) id = (<any>elem).id;
      for (; elem && elem !== <any>document; elem = elem.parentNode) {
        if (elem) {
          if ((<any>elem).id) id = (<any>elem).id;
          break;
        }
      }
      return "yasqe_" + id + "_query";
    },
    persistencyExpire: 60 * 60 * 24 * 30,

    hintConfig: {},
    resizeable: true,
    editorHeight: "300px",
  };
  return { ...config };
}
