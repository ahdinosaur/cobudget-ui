var port = process.env.PORT or 5000
require('./src/coffee')
require('./src/server').listen(port)
