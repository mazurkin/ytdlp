SHELL            := /bin/bash
ROOT             := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DATE             := $(shell date '+%Y%m%d-%H%M%S')

CONDA_ENV_NAME    = ytdlp

PYTHON_VERSION    = 3.12.15
POETRY_VERSION    = 2.5.1
FFMPEG_VERSION    = 8.1.2
DENOJS_VERSION    = 2.9.8

# -----------------------------------------------------------------------------
# defaults
# -----------------------------------------------------------------------------

.DEFAULT_GOAL = env-shell

# -----------------------------------------------------------------------------
# conda environment
# -----------------------------------------------------------------------------

.PHONY: env-create
env-create:
	@conda create --yes --copy --name "$(CONDA_ENV_NAME)" \
		conda-forge::python=$(PYTHON_VERSION) \
		conda-forge::poetry=$(POETRY_VERSION) \
		conda-forge::ffmpeg=$(FFMPEG_VERSION) \
		conda-forge::deno=$(DENOJS_VERSION)

.PHONY: env-poetry-install
env-poetry-install:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		poetry install \
			--no-interaction \
          	--no-ansi \
          	--no-root \
			--no-directory

.PHONY: env-poetry-update
env-poetry-update:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		poetry update

.PHONY: env-poetry-show
env-poetry-show:
	@bin/run poetry show --tree

.PHONY: env-poetry-lock
env-poetry-lock:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		poetry lock --no-update

.PHONY: env-remove
env-remove:
	@conda env remove --name "$(CONDA_ENV_NAME)" --yes

.PHONY: env-shell
env-shell: export PATH := $(ROOT)/bin:${PATH}
env-shell:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		bash

.PHONY: env-info
env-info:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		conda info

.PHONY: env-list
env-list:
	@conda run --no-capture-output --live-stream --name "$(CONDA_ENV_NAME)" \
		conda list
