# Workspace Rules

## Clean Up Temporary Scripts
Whenever you create temporary scripts (like `fix_xyz.py`, `test.py`, `parse.js`, etc.) to modify code, analyze data, or run tests, you MUST delete them immediately after you are finished using them. 

Do not leave them cluttering the project directory. Only retain scripts if they are intended to be reused as part of the project's permanent workflow (in which case, they should be placed in the `scripts/` directory).

## Local Javascript Verification
If you make changes to the Javascript engine inside `public/index.html`, you MUST test the syntax locally before you commit and push to production. 
Because Node.js is not installed on this machine, you must use macOS's built-in Javascript engine via the terminal:
`osascript -l JavaScript -e "$(cat public/index.html | grep -o '<script>.*</script>' || awk '/<script>/{flag=1; next} /<\/script>/{flag=0} flag')"`
If it throws `ReferenceError: Can't find variable: window`, it means the syntax successfully parsed.
