using System;
using System.Collections.Generic;
using System.Linq;

using Foundation;
using UIKit;

using Xamarin;

namespace TestFairySampleiOS
{
	public class Application
	{
		// This is the main entry point of the application.
		static void Main (string[] args)
		{
			Insights.Initialize ("059a418fbc7442f0f850e7052d429db75755e5e5");
			// if you want to use a different Application Delegate class from "AppDelegate"
			// you can specify it here.
			UIApplication.Main (args, null, "AppDelegate");
		}
	}
}
