ifndef TRAVIS_TAG
VERSION=2.0.0
else
VERSION=${TRAVIS_TAG}
endif
MONO_VERSION=4.4.0
XAMARIN_MAC_VERSION=2.8.0.58
XAMARIN_ANDROID_VERSION=6.0.3-5
XAMARIN_IOS_VERSION=9.6.1.9
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
	wget -nv "http://download.mono-project.com/archive/${MONO_VERSION}/macos-10-universal/MonoFramework-MDK-${MONO_VERSION}.macos10.xamarin.universal.pkg"
	wget -nv "http://download.xamarin.com/XamarinforMac/Mac/xamarin.mac-${XAMARIN_MAC_VERSION}.pkg"
	wget -nv "http://download.xamarin.com/MonoforAndroid/Mac/xamarin.android-${XAMARIN_ANDROID_VERSION}.pkg"
	wget -nv "http://download.xamarin.com/MonoTouch/Mac/xamarin.ios-${XAMARIN_IOS_VERSION}.pkg"
	curl -s -L -o xpkg.zip https://xampubdl.blob.core.windows.net/xamarin-download/xamarin-components/xamarin-component.zip
	sudo installer -pkg "MonoFramework-MDK-${MONO_VERSION}.macos10.xamarin.universal.pkg" -target /
	sudo installer -pkg "xamarin.mac-${XAMARIN_MAC_VERSION}.pkg" -target /
	sudo installer -pkg "xamarin.ios-${XAMARIN_IOS_VERSION}.pkg" -target /
	sudo installer -pkg "xamarin.android-${XAMARIN_ANDROID_VERSION}.pkg" -target /
	unzip xpkg.zip xamarin-component.exe
	rm xpkg.zip
