ALL_FILES_SH := $(shell find -name "*.sh")

# Check all .sh files with `shellcheck`
check:
	@$(foreach file, \
	  $(ALL_FILES_SH), \
	  echo "#################################################"; \
	  echo "Checking $(file)";  \
	  echo "#################################################"; \
	  shellcheck $(file) || exit 1; \
	)

