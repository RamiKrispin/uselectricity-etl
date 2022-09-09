#!/bin/bash

echo "Build the docker"

docker build . --progress=plain \
               --build-arg QUARTO_VERSION=1.1.149 \
               --build-arg CONDA_ENV=us_electricity_etl \
               --build-arg PYTHON_VER=3.10 \
               -t rkrispin/us_electricity_etl:dev.0.0.0.9000

if [[ $? = 0 ]] ; then
echo "Pushing docker..."
docker push rkrispin/us_electricity_etl:dev.0.0.0.9000
else
echo "Docker build failed"
fi