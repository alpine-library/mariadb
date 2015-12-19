#!/bin/bash
set -e

name='mariadb'
namespace='alpinelib'

declare -A aliases
aliases=(
	["10.1"]='10 latest'
)

versions=( */ )
versions=( "${versions[@]%/}" )

for version in "${versions[@]}"; do

  fullVersion="$(grep -m1 'ENV MYSQL_VERSION ' "$version/Dockerfile" | cut -d' ' -f3)"

	versionAliases=()

	while [ "$fullVersion" != "$version" -a "${fullVersion%[.-]*}" != "$fullVersion" ]; do
		versionAliases+=( $fullVersion )
		fullVersion="${fullVersion%[.-]*}"
	done

	versionAliases+=( $version ${aliases[$version]} )

  cd $version
  echo "build docker image $version"
  ID=$(docker build .  | tail -1 | sed 's/.*Successfully built \(.*\)$/\1/')
  cd ..

	for va in "${versionAliases[@]}"; do
    echo "TAG image $ID -> $namespace/$name:$va"
    docker tag -f $ID $namespace/$name:$va
    if [ $PUSH_IMAGE ]; then
    echo "PUSH image $ID -> $namespace/$name:$va"
    docker push $namespace/$name:$va
    fi
	done
done
