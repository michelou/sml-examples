##
## Copyright (c) 2018-2025 Stéphane Micheloud
##
## Licensed under the MIT License.
##
##############################################################################

TOOLSET ?= smlnj

include ../Makefile.inc

SOURCE_DIR  = src
TARGET_DIR  = target

##############################################################################
## main rules

SOURCES  = $(shell $(FIND) "$(SOURCE_DIR)" -type f -name "*.sml")

MAIN_ARGS =

IMAGE_MAIN = MainModule.main
IMAGE_NAME = args-image
IMAGE_FILE = $(TARGET_DIR)/$(IMAGE_NAME).x86-win32

all: build

ifeq ($(TOOLSET), smlnj)
build: $(IMAGE_FILE)
endif

$(IMAGE_FILE): $(SOURCES)
	[ -d "$(TARGET_DIR)" ] || "$(MKDIR)" -p "$(TARGET_DIR)"
	pushd "$(TARGET_DIR)" && \
	"$(ML_BUILD)" ../build.cm $(IMAGE_MAIN) $(IMAGE_NAME) && \
	popd

clean:
	"$(RM)" -rf "$(TARGET_DIR)"

run: build
	"$(SML)" @SMLload "$(IMAGE_FILE)" $(MAIN_ARGS)

help:
	@$(ECHO) "Usage: make all|build|clean|help|run"
	@$(ECHO) ""
	@$(ECHO) "   Subcommands:"
	@$(ECHO) "     all    alias for build"
	@$(ECHO) "     build  compile SML source files"
	@$(ECHO) "     clean  delete generated files"
	@$(ECHO) "     help   print this help message"
	@$(ECHO) "     run    execute main program \"$(IMAGE_NAME)\""

##############################################################################
## doc rules


##############################################################################
## test rules


##############################################################################
## phony

.PHONY: all build clean doc help run

.SUFFIXES:
.SUFFIXES: .sml .exe
