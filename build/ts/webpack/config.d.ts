import HtmlWebpackPlugin from "html-webpack-plugin";
import * as webpack from "webpack";
export declare const analyzeBundle: boolean;
export declare const indexPage: HtmlWebpackPlugin.Options;
export declare function getLinks(active?: "Yasgui" | "Yasqe" | "Yasr"): {
    href: string;
    text: string;
    className: string;
}[];
export declare const htmlConfigs: {
    [key: string]: HtmlWebpackPlugin.Options;
};
export declare const genericConfig: webpack.Configuration;
declare const config: webpack.Configuration;
export default config;
