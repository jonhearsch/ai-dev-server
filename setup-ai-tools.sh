#!/bin/bash
set -e

echo "========================================="
echo "AI Tools Setup Script"
echo "========================================="
echo ""

# Check if already installed
CLAUDE_INSTALLED=false
GEMINI_INSTALLED=false

if command -v claude &> /dev/null; then
    echo "✓ Claude Code is already installed"
    CLAUDE_INSTALLED=true
else
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | sh
    echo "✓ Claude Code installed successfully"
fi

if command -v genai &> /dev/null || npm list -g @google/generative-ai &> /dev/null; then
    echo "✓ Gemini CLI is already installed"
    GEMINI_INSTALLED=true
else
    echo "Installing Gemini CLI..."
    npm install -g @google/generative-ai
    echo "✓ Gemini CLI installed successfully"
fi

echo ""
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""

if [ "$CLAUDE_INSTALLED" = false ]; then
    echo "Claude Code has been installed. You can now use:"
    echo "  $ claude"
    echo ""
    echo "Note: You may need to configure your API key:"
    echo "  $ claude config"
    echo ""
fi

if [ "$GEMINI_INSTALLED" = false ]; then
    echo "Gemini CLI has been installed. You can now use:"
    echo "  $ npx @google/generative-ai"
    echo ""
fi

echo "To run this setup again: ~/setup-ai-tools.sh"
echo ""
