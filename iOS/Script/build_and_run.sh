# xcrun xcodebuild \
#   -scheme GCWebContainerDemo \
#   -workspace GCWebContainerDemo.xcworkspace/ \
#   -configuration Debug \
#   -destination 'id=88AE93EB-B12C-41F6-A479-E8F22E3B8365' \
#   -derivedDataPath \
#   build

#https://stackoverflow.com/questions/34003723/build-and-run-an-app-on-simulator-using-xcodebuild
APP="/Users/chenjiahao/Projects/GCWebContainerDemo/iOS/build/Build/Products/Debug-iphonesimulator/GCWebContainerDemo.app"
IPADPRO="88AE93EB-B12C-41F6-A479-E8F22E3B8365"

xcrun simctl install $IPADPRO $APP
