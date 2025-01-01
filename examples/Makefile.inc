ifndef GIT_HOME
$(error Variable GIT_HOME is not set)
endif
ifndef MOSML_HOME
$(error Variable MOSML_HOME is not set)
endif
ifndef SMLNJ_HOME
$(error Variable SMLNJ_HOME is not set)
endif

ifeq ($(OS),Windows_NT)
MOSML      = $(subst \,/,$(MOSML_HOME))/bin/mosml.exe
MOSMLC     = $(subst \,/,$(MOSML_HOME))/bin/mosmlc.exe
HOME       = $(subst \,/,$(USERPROFILE))
ML_BUILD   = $(subst \,/,$(SMLNJ_HOME))/bin/ml-build.bat
SML        = $(subst \,/,$(SMLNJ_HOME))/bin/sml.bat
PSEP       = ;
## $(MSYS_HOME)\usr\bin\{cp.exe, make.exe, wget.exe}
CP         = /usr/bin/cp.exe
CURL       = /usr/bin/curl.exe
ECHO       = /usr/bin/echo.exe
FIND       = /usr/bin/find.exe
MAKE       = /usr/bin/make.exe
MKDIR      = /usr/bin/mkdir.exe
RM         = /usr/bin/rm.exe
TOUCH      = /usr/bin/touch.exe
else
MOSML      = mosml
MOSMLC     = mosmlc
ML_BUILD   = ml-build
SML        = sml
PSEP       = :
CP         = cp
CURL       = curl
ECHO       = echo
FIND       = find
MAKE       = make
MKDIR      = mkdir
RM         = rm
TOUCH      = touch
endif
