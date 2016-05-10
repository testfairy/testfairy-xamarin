using Android.App;
using Android.Widget;
using Android.OS;
using Com.Testfairy;

namespace TestFairyAndroid
{
	[Activity (Label = "TestFairy", MainLauncher = true, Icon = "@mipmap/icon")]
	public class MainActivity : Activity
	{
		int count = 1;

		protected override void OnCreate (Bundle savedInstanceState)
		{
			base.OnCreate (savedInstanceState);

			TestFairy.Begin (this, "5b3af35e59a1e074e2d50675b1b629306cf0cfbd");

			// Set our view from the "main" layout resource
			SetContentView (Resource.Layout.Main);

			// Get our button from the layout resource,
			// and attach an event to it
			Button button = FindViewById<Button> (Resource.Id.myButton);
			
			button.Click += delegate {
				button.Text = string.Format ("{0} clicks!", count++);
			};
		}
	}
}


