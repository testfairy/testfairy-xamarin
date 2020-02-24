ifndef TRAVIS_TAG
VERSION=2.0.0
else
VERSION=${TRAVIS_TAG}
endif

NUGET_VERSION=v4.5.0
# From: https://www.mono-project.com/download/stable/
MONO_VERSION=https://download.mono-project.com/archive/6.8.0/macos-10-universal/MonoFramework-MDK-6.8.0.105.macos10.xamarin.universal.pkg
XAMARIN_MAC_VERSION=http://download.xamarin.com/XamarinforMac/Mac/xamarin.mac-2.8.0.58.pkg
# From: https://github.com/xamarin/xamarin-android/blob/master/README.md#downloads
XAMARIN_ANDROID_VERSION=https://download.visualstudio.microsoft.com/download/pr/fc059472-448e-4680-a3cd-e3ba032991c2/172ae06981e5555a4113c016179e6f2b/xamarin.android-10.1.3.7.pkg
# From: https://github.com/xamarin/xamarin-macios/releases (Replace XAMARIN_IOS_VERSION with latest version of xamarin.ios)
XAMARIN_IOS_VERSION=http://download.xamarin.com/MonoTouch/Mac/xamarin.ios-13.14.1.30.pkg

MSBUILD=/Library/Frameworks/Mono.framework//Versions/6.8.0/bin/msbuild

all: nuget
        zip -j9 output/TestFairy.Xamarin-Android.${TRAVIS_TAG}.zip output/TestFairy.Android.dll
        zip -j9 output/TestFairy.Xamarin-iOS.${VERSION}.zip output/TestFairy.iOS.dll

clean:
        ${MSBUILD} /p:Configuration=Release /t:Clean binding/TestFairy.Android/TestFairy.Android.csproj
        ${MSBUILD} /p:Configuration=Release /t:Clean binding/TestFairy.iOS/TestFairy.iOS.csproj
        rm -rf lib
        rm -rf output

TestFairy.iOS.dll:
        mkdir -p output
        ${MSBUILD} /p:Configuration=Release binding/TestFairy.iOS/TestFairy.iOS.csproj
        cp binding/TestFairy.iOS/bin/Release/TestFairy.iOS.dll output/.

TestFairy.Android.dll:
        mkdir -p output
        ${MSBUILD} /p:Configuration=Release binding/TestFairy.Android/TestFairy.Android.csproj
        cp binding/TestFairy.Android/bin/Release/TestFairy.Android.dll output/.

nuget: TestFairy.iOS.dll TestFairy.Android.dll
        xbuild --version
        sed -i '' -E "s/<version>[^<]+<\/version>/<version>${VERSION}<\/version>/g" nuget/TestFairy.nuspec
        mono nuget.exe pack nuget/TestFairy.nuspec -BasePath . -OutputDirectory ./output

install:
        wget -nv "https://dist.nuget.org/win-x86-commandline/${NUGET_VERSION}/nuget.exe"
        wget -O xamarin.universal.pkg -nv "${MONO_VERSION}"
        wget -O xamarin.mac.pkg       -nv "${XAMARIN_MAC_VERSION}"
        wget -O xamarin.android.pkg   -nv "${XAMARIN_ANDROID_VERSION}"
        wget -O xamarin.ios.pkg       -nv "${XAMARIN_IOS_VERSION}"
        sudo installer -pkg "xamarin.universal.pkg" -target /
        sudo installer -pkg "xamarin.mac.pkg" -target /
        sudo installer -pkg "xamarin.ios.pkg" -target /
        sudo installer -pkg "xamarin.android.pkg" -target /
