import { Prefixes } from "./prefixUtils";
import * as sparql11Mode from "../grammar/tokenizer";
import { default as YStorage } from "./utils/Storage";
import * as Autocompleter from "./autocompleters";
import CodeMirror from "./CodeMirror";
export interface Yasqe {
    showHint: (conf: HintConfig) => void;
    on(eventName: "error", handler: (instance: Yasqe) => void): void;
    off(eventName: "error", handler: (instance: Yasqe) => void): void;
    on(eventName: "blur", handler: (instance: Yasqe) => void): void;
    off(eventName: "blur", handler: (instance: Yasqe) => void): void;
    on(eventName: "autocompletionShown", handler: (instance: Yasqe, widget: any) => void): void;
    off(eventName: "autocompletionShown", handler: (instance: Yasqe, widget: any) => void): void;
    on(eventName: "autocompletionClose", handler: (instance: Yasqe) => void): void;
    off(eventName: "autocompletionClose", handler: (instance: Yasqe) => void): void;
    on(eventName: "resize", handler: (instance: Yasqe, newSize: string) => void): void;
    off(eventName: "resize", handler: (instance: Yasqe, newSize: string) => void): void;
    on(eventName: string, handler: () => void): void;
}
export declare class Yasqe extends CodeMirror {
    private static storageNamespace;
    autocompleters: {
        [name: string]: Autocompleter.Completer | undefined;
    };
    private prevQueryValid;
    queryValid: boolean;
    private resizeWrapper?;
    rootEl: HTMLDivElement;
    storage: YStorage;
    config: Config;
    persistentConfig: PersistentConfig | undefined;
    constructor(parent: HTMLElement, conf?: PartialConfig);
    private handleChange;
    private handleBlur;
    private handleChanges;
    private handleCursorActivity;
    private registerEventListeners;
    private unregisterEventListeners;
    emit(event: string, ...data: any[]): void;
    getStorageId(getter?: Config["persistenceId"]): string | undefined;
    private drawResizer;
    private initDrag;
    private calculateDragOffset;
    private doDrag;
    private stopDrag;
    duplicateLine(): void;
    handleLocalStorageQuotaFull(_e: any): void;
    saveQuery(): void;
    getQueryType(): "SELECT" | "CONSTRUCT" | "ASK" | "DESCRIBE" | "INSERT" | "DELETE" | "LOAD" | "CLEAR" | "CREATE" | "DROP" | "COPY" | "MOVE" | "ADD";
    getQueryMode(): "update" | "query";
    getVariablesFromQuery(): string[];
    private autoformatSelection;
    static autoformatString(text: string): string;
    commentLines(): void;
    autoformat(): void;
    getQueryWithValues(values: string | {
        [varName: string]: string;
    } | Array<{
        [varName: string]: string;
    }>): string;
    getValueWithoutComments(): string;
    setCheckSyntaxErrors(isEnabled: boolean): void;
    checkSyntax(): void;
    getCompleteToken(token?: Token, cur?: Position): Token;
    getPreviousNonWsToken(line: number, token: Token): Token;
    getNextNonWsToken(lineNumber: number, charNumber?: number): Token | undefined;
    private notificationEls;
    showNotification(key: string, message: string): void;
    hideNotification(key: string): void;
    enableCompleter(name: string): Promise<void>;
    disableCompleter(name: string): void;
    autocomplete(fromAutoShow?: boolean): void;
    collapsePrefixes(collapse?: boolean): void;
    getPrefixesFromQuery(): Prefixes;
    addPrefixes(prefixes: string | Prefixes): void;
    removePrefixes(prefixes: Prefixes): void;
    updateWidget(): void;
    expandEditor(): void;
    destroy(): void;
    static runMode: any;
    static clearStorage(): void;
    static Autocompleters: {
        [name: string]: Autocompleter.CompleterConfig;
    };
    static registerAutocompleter(value: Autocompleter.CompleterConfig, enable?: boolean): void;
    static defaults: {
        mode: string;
        collapsePrefixesOnLoad: boolean;
        syntaxErrorCheck: boolean;
        persistenceId: string | ((yasqe: Yasqe) => string);
        persistencyExpire: number;
        highlightSelectionMatches: {
            showToken?: RegExp;
            annotateScrollbar?: boolean;
        };
        tabMode: string;
        foldGutter: any;
        matchBrackets: boolean;
        autocompleters: string[];
        hintConfig: Partial<HintConfig>;
        resizeable: boolean;
        editorHeight: string;
        value?: any;
        theme?: string;
        indentUnit?: number;
        smartIndent?: boolean;
        tabSize?: number;
        indentWithTabs?: boolean;
        electricChars?: boolean;
        rtlMoveVisually?: boolean;
        keyMap?: string;
        extraKeys?: string | import("codemirror").KeyMap;
        lineWrapping?: boolean;
        lineNumbers?: boolean;
        firstLineNumber?: number;
        lineNumberFormatter?: (line: number) => string;
        gutters?: string[];
        fixedGutter?: boolean;
        scrollbarStyle?: string;
        coverGutterNextToScrollbar?: boolean;
        inputStyle?: import("codemirror").InputStyle;
        readOnly?: any;
        screenReaderLabel?: string;
        showCursorWhenSelecting?: boolean;
        lineWiseCopyCut?: boolean;
        pasteLinesPerSelection?: boolean;
        selectionsMayTouch?: boolean;
        undoDepth?: number;
        historyEventDelay?: number;
        tabindex?: number;
        autofocus?: boolean;
        dragDrop?: boolean;
        allowDropFileTypes?: string[];
        onDragEvent?: (instance: import("codemirror").Editor, event: DragEvent) => boolean;
        onKeyEvent?: (instance: import("codemirror").Editor, event: KeyboardEvent) => boolean;
        cursorBlinkRate?: number;
        cursorScrollMargin?: number;
        cursorHeight?: number;
        resetSelectionOnContextMenu?: boolean;
        workTime?: number;
        workDelay?: number;
        pollInterval?: number;
        flattenSpans?: boolean;
        addModeClass?: boolean;
        maxHighlightLength?: number;
        viewportMargin?: number;
        spellcheck?: boolean;
        autocorrect?: boolean;
        autocapitalize?: boolean;
        lint?: boolean | import("codemirror").LintStateOptions | import("codemirror").Linter | import("codemirror").AsyncLinter;
    };
    static forkAutocompleter(fromCompleter: string, newCompleter: {
        name: string;
    } & Partial<Autocompleter.CompleterConfig>, enable?: boolean): void;
}
export declare type TokenizerState = sparql11Mode.State;
export declare type Position = CodeMirror.Position;
export declare type Token = CodeMirror.Token;
export interface HintList {
    list: Hint[];
    from: Position;
    to: Position;
}
export interface Hint {
    text: string;
    displayText?: string;
    className?: string;
    render?: (el: HTMLElement, self: Hint, data: any) => void;
    from?: Position;
    to?: Position;
}
export declare type HintFn = {
    async?: boolean;
} & (() => Promise<HintList> | HintList);
export interface HintConfig {
    completeOnSingleClick?: boolean;
    container?: HTMLElement;
    closeCharacters?: RegExp;
    completeSingle?: boolean;
    hint: HintFn;
    alignWithWord?: boolean;
    closeOnUnfocus?: boolean;
    customKeys?: any;
    extraKeys?: {
        [key: string]: (yasqe: Yasqe, event: {
            close: () => void;
            data: {
                from: Position;
                to: Position;
                list: Hint[];
            };
            length: number;
            menuSize: () => void;
            moveFocus: (movement: number) => void;
            pick: () => void;
            setFocus: (index: number) => void;
        }) => void;
    };
}
export declare type PartialConfig = {
    [P in keyof Config]?: Config[P] extends object ? Partial<Config[P]> : Config[P];
};
export interface Config extends Partial<CodeMirror.EditorConfiguration> {
    mode: string;
    collapsePrefixesOnLoad: boolean;
    syntaxErrorCheck: boolean;
    persistenceId: ((yasqe: Yasqe) => string) | string | undefined | null;
    persistencyExpire: number;
    highlightSelectionMatches: {
        showToken?: RegExp;
        annotateScrollbar?: boolean;
    };
    tabMode: string;
    foldGutter: any;
    matchBrackets: boolean;
    autocompleters: string[];
    hintConfig: Partial<HintConfig>;
    resizeable: boolean;
    editorHeight: string;
}
export interface PersistentConfig {
    query: string;
    editorHeight: string;
}
export default Yasqe;
