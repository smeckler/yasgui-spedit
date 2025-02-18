import "./TabPanel.scss";
import Tab from "./Tab";
export default class TabPanel {
    menuElement: HTMLElement;
    settingsButton: HTMLButtonElement;
    tab: Tab;
    rootEl: HTMLElement;
    isOpen: boolean;
    constructor(tab: Tab, rootEl: HTMLElement, controlBarEl: HTMLElement);
    private init;
    private updateBody;
    open(ev: MouseEvent): void;
    close(_event?: MouseEvent): void;
    private toggleAriaSettings;
    private setRequestMethod;
    private drawRequestMethodSelector;
    private setAcceptHeader_select;
    private setAcceptHeader_graph;
    private drawAcceptSelector;
    private setArguments;
    private drawArgumentsInput;
    private setHeaders;
    private drawHeaderInput;
    private setDefaultGraphs;
    private drawDefaultGraphInput;
    private setNamedGraphs;
    private drawNamedGraphInput;
    private drawBody;
    destroy(): void;
}
