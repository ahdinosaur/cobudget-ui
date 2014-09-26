require('node-cjsx').transform({ extension: '.cjsx' });
require('node-jsx').install({ extension: '.jsx' });

require('./src/server.coffee');
