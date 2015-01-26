# Getting Started with TestFairy.Xamarin-iOS

Open `AppDelegate.cs` in your solution, and override or add the following code to `FinishedLaunching`. Don't forget to replace
<TESTFAIRY_APP_TOKEN> with your token from http://app.testfairy.com/settings/.

```
using TestFairyLib;

public override bool FinishedLaunching (UIApplication app, NSDictionary options)
{
	TestFairy.Begin ("TESTFAIRY_APP_TOKEN");

	// Rest of the method here
	// ...
}
```

## Telling TestFairy what to record

TestFairy can record screen cast directly from the device, it can monitor CPU consumption and memory allocations. It grabs
logs and even lets your users provide feedback upon device shake. 

To configure how and what TestFairy records, visit your build settings. You will see the build after calling Begin () at
least once.

## Mixing with other crash handlers

TestFairy plays nice. There is no problem using the crash handler with another reporter. 

