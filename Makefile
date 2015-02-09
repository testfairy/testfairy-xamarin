VERSION=1.3.0
OUTPUT=component/TestFairy.Xamarin-iOS-${VERSION}.xam

all: $(OUTPUT)

lib/ios-unified/TestFairy.iOS.dll:
	mkdir -p lib/ios-unified
	curl -s -o TestFairySDK-${VERSION}-Xamarin-Unified.zip https://app.testfairy.com/ios-sdk/TestFairySDK-${VERSION}-Xamarin-Unified.zip
	unzip -q -d lib/ios-unified TestFairySDK-${VERSION}-Xamarin-Unified.zip TestFairy.iOS.dll
	-rm -f TestFairySDK-${VERSION}-Xamarin-Unified.zip

bin/xamarin-component.exe:
	# Fetch latest xamarin-component executable
	wget https://components.xamarin.com/submit/xpkg
	-mkdir bin
	unzip -d bin xpkg xamarin-component.exe

$(OUTPUT): bin/xamarin-component.exe lib/ios-unified/TestFairy.iOS.dll
	mono bin/xamarin-component.exe package component

	# Make sure the .dll made it into the .xam package
	unzip -v $(OUTPUT) | grep TestFairy.iOS.dll > /dev/null

clean:
	-rm -f lib/ios-unified/TestFairy.iOS.dll $(OUTPUT)
