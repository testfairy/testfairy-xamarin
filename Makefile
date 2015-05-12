VERSION=1.4.4
OUTPUT=component/TestFairy.Xamarin-iOS-${VERSION}.xam

all: $(OUTPUT)

lib/ios-unified/TestFairy.iOS.dll:
	mkdir -p lib/ios-unified
	curl -s -L -o TestFairySDK-${VERSION}-Xamarin-Unified.zip https://app.testfairy.com/ios-sdk/TestFairySDK-${VERSION}-Xamarin-Unified.zip
	unzip -q -d lib/ios-unified TestFairySDK-${VERSION}-Xamarin-Unified.zip TestFairy.iOS.dll
	-rm -f TestFairySDK-${VERSION}-Xamarin-Unified.zip

lib/ios-classic/TestFairy.iOS.dll:
	mkdir -p lib/ios-classic
	curl -s -L -o TestFairySDK-${VERSION}-Xamarin-Classic.zip https://app.testfairy.com/ios-sdk/TestFairySDK-${VERSION}-Xamarin-Classic.zip
	unzip -q -d lib/ios-classic TestFairySDK-${VERSION}-Xamarin-Classic.zip TestFairy.iOS.dll
	-rm -f TestFairySDK-${VERSION}-Xamarin-Classic.zip

bin/xamarin-component.exe:
	# Fetch latest xamarin-component executable
	-mkdir bin
	curl -s -L -o bin/xpkg.zip https://components.xamarin.com/submit/xpkg
	unzip -d bin bin/xpkg.zip xamarin-component.exe
	-rm -f bin/xpkg.zip

$(OUTPUT): bin/xamarin-component.exe lib/ios-unified/TestFairy.iOS.dll lib/ios-classic/TestFairy.iOS.dll
	sed -i '' "s/^version:.*/version: $(VERSION)/" component/component.yaml 
	mono bin/xamarin-component.exe package component
	# Make sure the .dll made it into the .xam package
	unzip -v $(OUTPUT) | grep lib/ios/TestFairy.iOS.dll > /dev/null
	unzip -v $(OUTPUT) | grep lib/ios-unified/TestFairy.iOS.dll > /dev/null

clean:
	-rm -f bin/xamarin-component.exe
	-rm -f bin/xpkg
	-rmdir bin 2>/dev/null
	-rm -f $(OUTPUT)
	-rm -f lib/ios-unified/TestFairy.iOS.dll 
	-rm -f lib/ios-classic/TestFairy.iOS.dll 
	-rm -rf samples/TestFairySampleiOS/TestFairySampleiOS/obj
