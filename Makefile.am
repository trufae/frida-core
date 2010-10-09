RURL := root@${IOS_IPADDR}
RPFX := ${prefix}

ACLOCAL_AMFLAGS = -I m4

SUBDIRS = \
	lib

if ENABLE_CLIENT
SUBDIRS += tools
SUBDIRS += src
endif

if ENABLE_SERVER
SUBDIRS += server
endif

deploy: all
	ssh "${RURL}" "mkdir -p ${RPFX}/{sbin,lib/zed}/"
	scp -Bq "$(top_builddir)/server/src/zed-server" "${RURL}:${RPFX}/sbin/"
	scp -Bq "$(top_builddir)/lib/agent/.libs/libzed-agent.dylib" "${RURL}:${RPFX}/lib/zed/zed-agent.dylib"

check: all
	ssh "${RURL}" "mkdir -p ${RPFX}/tests/"
	scp -Bq "$(top_builddir)/server/tests/zed-server-tests" "${RURL}:${RPFX}/tests/"
	scp -Bq "$(top_builddir)/server/tests/inject-victim" "${RURL}:${RPFX}/tests/"
	scp -Bq "$(top_builddir)/server/tests/.libs/libinject-attacker.dylib" "${RURL}:${RPFX}/tests/inject-attacker.dylib"
	ssh "${RURL}" "${RPFX}/tests/zed-server-tests"