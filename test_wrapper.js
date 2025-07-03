const { spawn } = require('child_process');

// Get the odata-mcp path
const odataMcpPath = './odata-mcp';

// Spawn the process
const child = spawn(odataMcpPath, process.argv.slice(2), {
  stdio: ['inherit', 'inherit', 'inherit']
});

// Handle exit
child.on('exit', (code) => {
  process.exit(code);
});
