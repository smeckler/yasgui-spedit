const JsUri = require("jsuri");

import { default as Tab, PersistedJson } from "./Tab";
import Yasr from "@triply/yasr";

export type RequestArgs = { [argName: string]: string | string[] };
export function appendArgsToUrl(_url: string, args: RequestArgs): string {
  var url = new JsUri(_url);
  for (const arg in args) {
    const val = args[arg];
    if (Array.isArray(val)) {
      for (const subVal of val) {
        url.addQueryParam(arg, subVal);
      }
    } else {
      url.addQueryParam(arg, val);
    }
  }
  return url.toString();
}

export function queryCatalogConfigToTabConfig<Q extends QueryCatalogConfig>(
  catalogConfig: Q,
  defaults?: PersistedJson
): PersistedJson {
  const options = defaults || Tab.getDefaults();

  if (catalogConfig.renderConfig) {
    if (catalogConfig.renderConfig.output) {
      if (Yasr.plugins[catalogConfig.renderConfig.output]) {
        options.yasr.settings.selectedPlugin = catalogConfig.renderConfig.output;
      } else {
        console.warn(`Output format plugin "${catalogConfig.renderConfig.output}" not found`);
      }
    }
    if (catalogConfig.renderConfig.settings) {
      if (Yasr.plugins[catalogConfig.renderConfig.output] && options.yasr.settings.pluginsConfig) {
        options.yasr.settings.pluginsConfig[catalogConfig.renderConfig.output] = catalogConfig.renderConfig.settings;
      } else {
        console.warn(`Output format plugin "${catalogConfig.renderConfig.output}" not found, cannot apply settings`);
      }
    }
  }
  if (catalogConfig.name) {
    options.name = catalogConfig.name;
  }
  return options;
}

export interface QueryCatalogConfig {
  service: string;
  name: string;
  description: string;
  requestConfig?: {
    payload: {
      query: string;
      "default-graph-uri"?: string | string[];
      "named-graph-uri"?: string | string[];
    };
    headers?: {
      [key: string]: string;
    };
  };
  renderConfig?: {
    output: string;
    settings?: any;
  };
}
