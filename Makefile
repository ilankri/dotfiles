SHELL = /bin/sh
LN = ln -fs
MKDIR = mkdir -p
CP = cp -r

srcdir = $(shell pwd)
aptdir = $(srcdir)/apt
bashdir = $(srcdir)/bash
bindir = $(srcdir)/bin
dockerdir = $(srcdir)/docker
dockerinstalldir = ~/.docker
emacsdir = $(srcdir)/emacs
elispdir = $(emacsdir)/lisp
gitdir = $(srcdir)/git
ocamldir = $(srcdir)/ocaml
ocpdir = $(srcdir)/ocp
ocpinstalldir = ~/.ocp
readlinedir = $(srcdir)/readline
print_installing = printf "Installing %s config... "
print_done = echo "done."

.SUFFIXES:
.PHONY: all install clean install-apt install-bash install-bin	\
	install-docker install-emacs install-git install-ocaml	\
	install-ocp install-readline compile-emacs-lisp

all: install

install: install-apt install-bash install-bin install-docker		\
		install-emacs install-git install-ocaml install-ocp	\
		install-readline

clean:
	@$(RM) $(elispdir)/*.elc

install-apt:
	@$(print_installing) APT
	@$(CP) $(aptdir) /etc
	@$(print_done)

install-bash:
	@$(print_installing) Bash
	@$(LN) $(bashdir)/bashrc.bash ~/.bashrc
	@$(LN) $(bashdir)/bash_aliases.bash ~/.bash_aliases
	@$(print_done)

install-bin:
	@echo -n "Installing user's bin... "
	@$(LN) $(bindir) ~
	@$(print_done)

install-docker:
	@$(print_installing) Docker
	@$(MKDIR) $(dockerinstalldir)
	@$(LN) $(dockerdir)/config.json $(dockerinstalldir)
	@$(print_done)

install-emacs: compile-emacs-lisp
	@$(print_installing) Emacs
	@emacs --batch --eval \
		"(progn $(head -n 4 emacs/init.el) (package-refresh-contents))"
	@$(LN) $(emacsdir)/gnus-init.el $(emacsdir)/signature		\
		$(emacsdir)/init.el $(emacsdir)/insert $(elispdir)	\
		~/.emacs.d
	@$(print_done)

install-git:
	@$(print_installing) Git
	@$(LN) $(gitdir)/gitconfig ~/.gitconfig
	@$(LN) $(gitdir)/gitignore ~/.gitignore
	@$(print_done)

install-ocaml:
	@$(print_installing) OCaml
	@$(LN) $(ocamldir)/ocamlinit.ml ~/.ocamlinit
	@$(print_done)

install-ocp:
	@$(print_installing) OCP
	@$(MKDIR) $(ocpinstalldir)
	@$(LN) $(ocpdir)/ocp-indent.conf $(ocpinstalldir)
	@$(print_done)

install-readline:
	@$(print_installing) Readline
	@$(LN) $(readlinedir)/inputrc ~/.inputrc
	@$(print_done)

compile-emacs-lisp:
	@echo "Compiling Elisp files... "
	@emacs --batch --eval '(batch-byte-recompile-directory 0)'	\
		$(elispdir)
