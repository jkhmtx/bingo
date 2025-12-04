# shellcheck shell=bash

echo "The following repo commands are available:"
echo
while read -r attrname _; do
	echo "  ${attrname}"
done < <(grep -v '.lib.')
echo
