echo "running pre-commit hook...";
gdscripts=$( git diff --staged --name-only "*.gd" );
echo "staged scripts = $gdscripts";
if [ -n "$gdscripts" ]; then
	gdformat $gdscripts &&
	git add $gdscripts;
fi
result=$?;
echo "pre-commit hook done!" && exit $result;
