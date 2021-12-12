const TerserPlugin = require("terser-webpack-plugin");

module.exports = {
  entry: __dirname + "/src/index.js",
  output: {
    path: __dirname + '/build',
    filename: 'jsbridge.js'
  },
  optimization: {
    minimize: true,
    minimizer: [
      new TerserPlugin({
        terserOptions: {
          keep_classnames: true,
          keep_fnames: true
        }
      })
    ]
  },
};