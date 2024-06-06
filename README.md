# Jupyter Deno Notebooks

Use a docker container to run python and JavaScript in jupyter notebooks.

## Dockerfile

The `Dockerfile` in this repository will build a simple container based on `deno:alpine`. Its purpose is to run `jupyter notebooks` with a specific set of dependencies.

### Dependencies

It installs `python` and `jupyter labs`, `matplotlib` and `pandas`, as well as a `deno kernel`. Deno makes it possible to also run JavaScript in jupyter notebooks. 

### Extras

Additionally `jupyter labs` will be configured to default to its dark mode. It also installs `vim`. Because the best text editor always comes in handy.

## Build the container

```bash
docker build -t jupyter-deno-books:0.1
```

## Run the container

```bash
# run it in cwd
# store notebooks on the host machine
# in `./notebooks`
mkdir notebooks
docker run                                  \ 
    -it                                      \ 
    --rm                                      \ 
    --name jupy                                \
    -p 8888:8888                                \ 
    --volume $(pwd)/notebooks:/jupyter_notebooks \
    jupyter-deno-books:0.1 .                      \
```

## Stop the container

```bash
docker stop jupy
```

## Script

There is a script in this repository, `jupy.sh`. It can help with creating, starting, and stopping the container. It also creates a directory on your host machine to store notebooks in. And allows to configure the path to this directory using an `.env` file. For more information on how to use the script, run `bash ./jupy.sh -h`.

