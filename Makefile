# Check all .sh files with `shellcheck`
check:
	@$(foreach file, \
	  $(wildcard *.sh), \
	  echo "#################################################"; \
	  echo "Checking $(file)";  \
	  echo "#################################################"; \
	  shellcheck $(file); \
	)

