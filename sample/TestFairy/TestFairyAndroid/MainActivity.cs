using Android.App;
using Android.Views;
using Android.Widget;
using Android.Views.Animations;
using Android.OS;
using Com.Testfairy;

namespace TestFairyAndroid
{
	[Activity (Label = "TestFairy", MainLauncher = true, Icon = "@mipmap/icon")]
	public class MainActivity : Activity
	{
		protected override void OnCreate (Bundle savedInstanceState)
		{
			base.OnCreate (savedInstanceState);

			// Invoke TestFairy begin to start session recording
			TestFairy.Begin (this, "5b3af35e59a1e074e2d50675b1b629306cf0cfbd");

			// Set our view from the "main" layout resource
			SetContentView (Resource.Layout.Main);

			var animation = AnimationUtils.LoadAnimation(this, Resource.Animation.rotate_centre);
			View rotating = FindViewById<View> (Resource.Id.rotating_box);
			rotating.StartAnimation (animation);

			View hidden = FindViewById<View> (Resource.Id.secret_text);
			TestFairy.HideView (hidden);
		}
	}
}


