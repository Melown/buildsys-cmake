# This file can be included into debian/rules to add default package handling
# for buildsys-cmake based projects

# sanity check
ifndef PACKAGES
$(error Missing PACKAGES variable)
endif

# use this build directory
DEB_BUILDDIR=obj-$(DEB_BUILD_GNU_TYPE)

# default rule; tell debhelper we use CMake
%:
	dh -Scmake -B$(DEB_BUILDDIR) --parallel -O--version-info $@

# custom installation
override_dh_auto_install:
	$(foreach package, $(PACKAGES) \
	  , $(foreach component, $(INSTALL_COMPONENTS_$(package)) \
		  , DESTDIR=debian/$(DEB_PACKAGE_$(package)) \
			cmake -DCOMPONENT=$(component) \
			    -P $(DEB_BUILDDIR)/cmake_install.cmake;))
