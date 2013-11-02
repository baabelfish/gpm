#!/bin/bash

echo "packages path $(./deps/JSON.sh/JSON.sh < example.gpm.json | sed -n 's/\["packages_path"\].*"\(.*\)"/\1/p')"

echo "found x packages:"
for pkg in $(./deps/JSON.sh/JSON.sh < example.gpm.json | sed -n 's/\["packages","\([^"]*\)"\].*/\1/p'); do
    echo "package" $pkg

    for key in $(./deps/JSON.sh/JSON.sh < example.gpm.json | sed -n "s@\[\"packages\",\"${pkg}\",\"\([^\"]*\)\"\].*@\1@p"); do
        echo $key $(./deps/JSON.sh/JSON.sh < example.gpm.json | sed -n "s@\[\"packages\",\"${pkg}\",\"${key}\"\].*\"\(.*\)\".*@\1@p")
    done
done
