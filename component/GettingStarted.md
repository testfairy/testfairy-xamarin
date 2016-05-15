# TestFairy plugin for Xamarin

TestFairy is available for both Android and iOS. You can install the bindings by 1 of 3 ways

You will need an app token (TESTFAIRY_APP_TOKEN) which can be found in your [settings page](http://app.testfairy.com/settings/)

## iOS

Open `AppDelegate.cs` in your solution, and override or add the following code to `FinishedLaunching`.

```
using TestFairyLib;
...

public override bool FinishedLaunching (UIApplication app, NSDictionary options)
{
	TestFairy.Begin (TESTFAIRY_APP_TOKEN);

	// Rest of the method here
	// ...
}
```

## Android
Either in your custom Android Application class, or in any Activity class, simply make a call to Com.TestFairy.TestFairy.Begin(<TESTFAIRY_APP_TOKEN>). Below, we show an example of invoking begin from the Main Activity.

```
using Com.Testfairy;
...

public class MainActivity : Activity {
	protected override void OnCreate (Bundle savedInstanceState)
    {
		base.OnCreate (savedInstanceState);

		TestFairy.Begin (this, TESTFAIRY_APP_TOKEN);
		SetContentView (Resource.Layout.Main);
        ...
    }
}

```

## Telling TestFairy what to record

TestFairy can record screen cast directly from the device, it can monitor CPU consumption and memory allocations. It grabs
logs and even lets your users provide feedback upon device shake. 

To configure how and what TestFairy records, visit your build settings. You will see the build after calling Begin () at
least once.

## Mixing with other crash handlers

TestFairy plays nice. There is no problem using the crash handler with another reporter. 

## Where to go from here
For class reference, installation and more information, please visit 
[Xamarin integration document](http://docs.testfairy.com/Integrations/Xamarin.html) on TestFairy.
