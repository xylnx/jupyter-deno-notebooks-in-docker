## =========================================================
## Set up jupyter notebooks. 
## Additionally install `matplotlib` and `pandas`.
## And add a `deno kernel` to also run JS in notebooks.
## =========================================================

FROM --platform=linux/amd64 denoland/deno:alpine

# Container setup
RUN apk update

# Make sure to have the best text editor on board
RUN apk add vim

# Install and upgrade python's pip
RUN apk add py3-setuptools
RUN apk add py3-pip
RUN apk add --update py3-pip
RUN apk add --upgrade py3-pip

# Install data analysis tools
RUN apk add py3-matplotlib
RUN apk add py3-pandas

# Install deps needed to install jupyterlab
RUN apk add gcc musl-dev linux-headers python3-dev
RUN pip3 install jupyterlab --break-system-packages

# Install deno kernel (to also run JS notebooks)
RUN deno jupyter --unstable --install

WORKDIR /jupyter_notebooks

# Create a settings directory for config overrides
RUN mkdir /usr/share/jupyter/lab/settings

# Override default theme to dark
RUN echo '{"@jupyterlab/apputils-extension:themes": {"theme": "JupyterLab Dark"}}' >> /usr/share/jupyter/lab/settings/overrides.json

# Verrry unsafe, don't do this outside of a local environment
CMD ["jupyter", "lab", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
