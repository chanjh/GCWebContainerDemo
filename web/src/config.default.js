
const config = {
  bridgeName: 'invoke',
  global: 'gc',
  services: {
    util: {
      contextMenu: ['clear'],
      test: ['testMethod']
    },
    runtime: {
      system: {
        lifecyle: {
          app: ['willopen']
        }
      },
      test: ['testMethod']
    }
  }
};

export default config;