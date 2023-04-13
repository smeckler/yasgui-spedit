/// <reference types="node" />
import puppeteer from "puppeteer";
import * as http from "http";
import * as Mocha from "mocha";
export declare function setupServer(buildDir: string): Promise<http.Server | undefined>;
export declare function wait(time: number): Promise<unknown>;
export declare function inspectLive(mocha: Mocha.ISuiteCallbackContext): Promise<void>;
export declare function setup(ctx: Mocha.Context, buildDir: string): Promise<{
    server: http.Server;
    browser: puppeteer.Browser;
}>;
export declare function destroy(browser: puppeteer.Browser, server?: http.Server): Promise<void>;
export declare function getPage(browser: puppeteer.Browser, path: string): Promise<puppeteer.Page>;
export declare function makeScreenshot(page: puppeteer.Page, name?: string): Promise<Buffer>;
export declare function closePage(suite: Mocha.Suite, page: puppeteer.Page): Promise<void>;
