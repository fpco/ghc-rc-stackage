# ghc-rc-stackage

Helper repo for testing GHC release candidates against the Stackage package set

This repo contains a Dockerfile for generating a Docker image with the relevant
GHC, system libraries, and a `/stackage/build.sh` script for running the build.
See each of those files for more information. You can build the Docker image
yourself if desired with:

    docker build --tag fpco/ghc-rc-stackage .

This can be especially useful if you want to point to a newer GHC tarball than
referenced in this repo (though please consider sending a PR when new release
candidates are available). You can pull the latest upstream image with:

    docker pull fpco/ghc-rc-stackage

Regardless of whether you have a self-built or upstream Docker image, the
recommended approach for running it is to bind mount the build directory to
your host so you can analyze build objects and logs. A script for that is:

    docker run --rm -it -v `pwd`/build:/build -v `pwd`/fake-home:/fake-home -e USERID=`id -u` fpco/ghc-rc-stackage /stackage/build.sh
