#!/bin/bash

echo "Testing odata-mcp with MCP Inspector..."
echo
echo "This script will help test the MCP server compliance"
echo

# First, let's create a simple Node.js wrapper to test with the inspector
cat > test_wrapper.js << 'EOF'
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
EOF

echo "To test with MCP Inspector, run:"
echo
echo "1. Install the inspector:"
echo "   npx @modelcontextprotocol/inspector"
echo
echo "2. In another terminal, test the server:"
echo "   npx @modelcontextprotocol/inspector ./odata-mcp"
echo
echo "3. Or use CLI mode to run specific tests:"
echo "   npx @modelcontextprotocol/inspector --cli ./odata-mcp --method initialize"
echo "   npx @modelcontextprotocol/inspector --cli ./odata-mcp --method tools/list"
echo

# Run a quick compliance test
echo "Running basic compliance test..."
echo

# Test 1: Initialize
echo -n "Test 1 - Initialize: "
RESULT=$(echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{}}}' | ./odata-mcp 2>&1)
if echo "$RESULT" | grep -q '"protocolVersion":"2024-11-05"'; then
    echo "PASS"
else
    echo "FAIL"
    echo "$RESULT"
fi

# Test 2: Tools list
echo -n "Test 2 - Tools/list: "
RESULT=$(echo '{"jsonrpc":"2.0","id":2,"method":"tools/list"}' | ./odata-mcp 2>&1)
if echo "$RESULT" | grep -q '"tools":\['; then
    echo "PASS"
else
    echo "FAIL"
    echo "$RESULT"
fi

# Test 3: Resources list
echo -n "Test 3 - Resources/list: "
RESULT=$(echo '{"jsonrpc":"2.0","id":3,"method":"resources/list"}' | ./odata-mcp 2>&1)
if echo "$RESULT" | grep -q '"resources":\[\]'; then
    echo "PASS"
else
    echo "FAIL"
    echo "$RESULT"
fi

# Test 4: Unknown method
echo -n "Test 4 - Unknown method handling: "
RESULT=$(echo '{"jsonrpc":"2.0","id":4,"method":"unknown/method"}' | ./odata-mcp 2>&1)
if echo "$RESULT" | grep -q '"error"'; then
    echo "PASS"
else
    echo "FAIL"
    echo "$RESULT"
fi

echo
echo "Basic compliance tests complete."