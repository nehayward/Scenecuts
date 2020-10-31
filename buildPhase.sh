set -e

# if ! which swiftlint > /dev/null; then
#   echo "error: SwiftLint is not installed. Vistit http://github.com/realm/SwiftLint to learn more."
#   exit 1
# fi

echo "Hello"
# cp testing.txt ${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app

xcodebuild -alltargets clean
xcodebuild archive -scheme "ScenecutsHelper" -archivePath macCatalyst.xcarchive -sdk macosx SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES SUPPORTS_MACCATALYST=YES

# 
# xcodebuild archive \
# -scheme $SCHEME \
# -archivePath $ARCHS/macCatalyst.xcarchive \
# -sdk macosx \
# SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES SUPPORTS_MACCATALYST=YES
# 
# xcodebuild archive -scheme "ScenecutsHelper" -archivePath $ARCHS/macCatalyst.xcarchive -sdk macosx SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES SUPPORTS_MACCATALYST=YES
