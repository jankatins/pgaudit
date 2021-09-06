# contrib/pg_audit/Makefile

MODULE_big = pgaudit
OBJS = pgaudit.o $(WIN32RES)

EXTENSION = pgaudit
DATA = pgaudit--1.5.sql
PGFILEDESC = "pgAudit - An audit logging extension for PostgreSQL"

REGRESS = pgaudit
REGRESS_OPTS = --temp-config=$(top_srcdir)/contrib/pgaudit/pgaudit.conf

EXTVERSION = 1.5
PAST_VERSIONS = \
	1.4 1.4.1 \
	1.3 1.3.1 1.3.2 \
	1.2 1.2.1 1.2.2 \
	1.1 1.1.1 1.1.2 1.1.3 \
	1.0 1.0.6 1.0.7 1.0.8

DATA_built = $(EXTENSION)--ANY--$(EXTVERSION).sql

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/pgaudit
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif

$(EXTENSION)--ANY--$(EXTVERSION).sql:
	echo "\\echo Use "CREATE EXTENSION pgaudit" to load this file.\\quit\n" > $(EXTENSION)--ANY--$(EXTVERSION).sql

install: install-upgrade-paths
install-upgrade-paths:
	# Install all specific path as a symlink to the ANY file: this works as long as a single upgrade path script works
	tpl='$(EXTENSION)--ANY--$(EXTVERSION).sql'; \
	for PAST_VERSION in $(PAST_VERSIONS); do \
		ln -fs "$${tpl}" $(DESTDIR)$(datadir)/$(datamoduledir)/$(EXTENSION)--$$PAST_VERSION--$(EXTVERSION).sql; \
	done
