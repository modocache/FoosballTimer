class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication::sharedApplication.statusBarStyle = UIStatusBarStyleBlackOpaque

    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    tc = TimerViewController.alloc.init
    @window.rootViewController = tc
    @window.makeKeyAndVisible

    true
  end
end
