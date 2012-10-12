#!/bin/csh -e

foreach framework ($*)
	cp -Rv "${PROJECT_DIR}/Frameworks/$framework/build/${CONFIGURATION}-${PLATFORM_NAME}/usr/local/etc/$framework"/* \
			"${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
end
