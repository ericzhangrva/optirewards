const fs = require('fs');
const html = fs.readFileSync('index.html', 'utf8');
const scriptMatch = html.match(/<script>([\s\S]*?)<\/script>/);
if (scriptMatch) {
    const scriptContent = scriptMatch[1];
    try {
        const acorn = require('acorn');
        acorn.parse(scriptContent, { ecmaVersion: 2020 });
        console.log("No syntax errors!");
    } catch (e) {
        console.log("Syntax Error:", e);
    }
}
