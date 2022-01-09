const esbuild = require('esbuild');
const PureScriptPlugin = require('esbuild-plugin-purescript');
const { sassPlugin } = require('esbuild-sass-plugin');
const path = require('path');

const isDev = process.env.NODE_ENV === "development";

esbuild.build({
  entryPoints: ["app/renderer.js"],
  bundle: true,
  minify: !isDev,
  outfile: "app/lib/bundle.js",
  watch: isDev,
  loader: {
    ".png": "base64",
  },
  plugins: [
    PureScriptPlugin({
      output: path.resolve(__dirname, isDev ? "output" : "dce-output"),
    }),
    sassPlugin(),
  ],
}).catch(err => {
  console.error("Failed to bundle app via esbuild. Error: " + err.message)
});