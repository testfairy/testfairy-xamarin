ifndef TRAVIS_TAG
VERSION=2.0.0
else
VERSION=${TRAVIS_TAG}
endif

MONO_VERSION=MonoFramework-MDK-6.8.0.105.macos10.xamarin.universal.pkg
XAMARIN_MAC_VERSION=2.8.0.58
XAMARIN_ANDROID_VERSION=xamarin.android-10.1.3.7.pkg
XAMARIN_IOS_VERSION=13.14.1.30
NUGET_VERSION=v4.5.0

all: nuget
	zip -j9 output/TestFairy.Xamarin-Android.${TRAVIS_TAG}.zip output/TestFairy.Android.dll
	zip -j9 output/TestFairy.Xamarin-iOS.${VERSION}.zip output/TestFairy.iOS.dll

clean:
	xbuild /p:Configuration=Release /t:Clean binding/TestFairy.Android/TestFairy.Android.csproj
	xbuild /p:Configuration=Release /t:Clean binding/TestFairy.iOS/TestFairy.iOS.csproj
	rm -rf lib
	rm -rf output

TestFairy.iOS.dll:
	mkdir -p output
	xbuild /p:Configuration=Release binding/TestFairy.iOS/TestFairy.iOS.csproj
	cp binding/TestFairy.iOS/bin/Release/TestFairy.iOS.dll output/.

TestFairy.Android.dll:
	mkdir -p output
	xbuild /p:Configuration=Release binding/TestFairy.Android/TestFairy.Android.csproj
	cp binding/TestFairy.Android/bin/Release/TestFairy.Android.dll output/.

nuget: TestFairy.iOS.dll TestFairy.Android.dll
	xbuild --version
	sed -i '' -E "s/<version>[^<]+<\/version>/<version>${VERSION}<\/version>/g" nuget/TestFairy.nuspec
	mono nuget.exe pack nuget/TestFairy.nuspec -BasePath . -OutputDirectory ./output

install:
	wget -nv "https://dist.nuget.org/win-x86-commandline/${NUGET_VERSION}/nuget.exe"
	# From: https://www.mono-project.com/download/stable/
	wget -nv "https://download.mono-project.com/archive/6.8.0/macos-10-universal/${MONO_VERSION}"
	wget -nv "http://download.xamarin.com/XamarinforMac/Mac/xamarin.mac-${XAMARIN_MAC_VERSION}.pkg"
	# From: https://github.com/xamarin/xamarin-android/blob/master/README.md#downloads
	wget -nv "https://download.visualstudio.microsoft.com/download/pr/fc059472-448e-4680-a3cd-e3ba032991c2/172ae06981e5555a4113c016179e6f2b/"
	# From: https://github.com/xamarin/xamarin-macios/releases (Replace XAMARIN_IOS_VERSION with latest version of xamarin.ios)
	wget -nv "http://download.xamarin.com/MonoTouch/Mac/xamarin.ios-${XAMARIN_IOS_VERSION}.pkg"
	sudo installer -pkg "${MONO_VERSION}" -target /
	sudo installer -pkg "xamarin.mac-${XAMARIN_MAC_VERSION}.pkg" -target /
	sudo installer -pkg "xamarin.ios-${XAMARIN_IOS_VERSION}.pkg" -target /
	sudo installer -pkg "${XAMARIN_ANDROID_VERSION}" -target /
