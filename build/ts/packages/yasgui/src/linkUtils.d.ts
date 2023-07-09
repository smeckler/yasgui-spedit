import { PersistedJson } from "./Tab";
export declare type RequestArgs = {
    [argName: string]: string | string[];
};
export declare function appendArgsToUrl(_url: string, args: RequestArgs): string;
export declare function queryCatalogConfigToTabConfig<Q extends QueryCatalogConfig>(catalogConfig: Q, defaults?: PersistedJson): PersistedJson;
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
