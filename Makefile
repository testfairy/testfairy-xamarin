ifndef TRAVIS_TAG
VERSION=2.0.0
else
VERSION=${TRAVIS_TAG}
endif
MONO_VERSION="3.12.0"

all: nuget component

clean:
	xbuild /p:Configuration=Release /t:Clean binding/TestFairy.Android/TestFairy.Android.csproj
	xbuild /p:Configuration=Release /t:Clean binding/TestFairy.iOS/TestFairy.iOS.csproj
	rm -rf output

TestFairy.iOS.dll:
	mkdir -p output
	xbuild /p:Configuration=Release binding/TestFairy.iOS/TestFairy.iOS.csproj
	cp binding/TestFairy.iOS/bin/Release/TestFairy.iOS.dll output/.

TestFairy.Android.dll:
	mkdir -p output
	xbuild /p:Configuration=Release binding/TestFairy.Android/TestFairy.Android.csproj
	cp binding/TestFairy.Android/bin/Release/TestFairy.Android.dll output/.

component: TestFairy.Android.dll TestFairy.iOS.dll
	sed -i '' "s/^version:.*/version: ${VERSION}/" component/component.yaml
	mono xamarin-component.exe package component
	mv component/TestFairy.Xamarin-${VERSION}.xam output/.

nuget: TestFairy.Android.dll TestFairy.iOS.dll
	sed -i '' -E "s/<version>[^<]+<\/version>/<version>${VERSION}<\/version>/g" nuget/TestFairy.nuspec
	mono nuget.exe pack nuget/TestFairy.nuspec -BasePath . -OutputDirectory ./output

install:
	wget "http://nuget.org/nuget.exe"
	wget "http://download.mono-project.com/archive/${MONO_VERSION}/macos-10-x86/MonoFramework-MDK-${MONO_VERSION}.macos10.xamarin.x86.pkg"
	sudo installer -pkg "MonoFramework-MDK-${MONO_VERSION}.macos10.xamarin.x86.pkg" -target /
	curl -s -L -o xpkg.zip https://components.xamarin.com/submit/xpkg
	unzip xpkg.zip xamarin-component.exe
	rm xpkg.zip
