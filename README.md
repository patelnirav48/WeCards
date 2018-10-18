# WeCards
The WeCards Sign-In iOS quick start demonstrates how to authenticate people with their WeCards credentials.

# Requirements

    iOS 8.0+ / macOS 10.13+
    Xcode 10.0+
    Swift 4.2+
    
# Installation

<h3>Carthage</h3>

<p><a href="https://github.com/Carthage/Carthage">Carthage</a> is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.</p>

<p>You can install Carthage with <a href="https://brew.sh/" rel="nofollow">Homebrew</a> using the following command:</p>
<div class="highlight highlight-source-shell"><pre>$ brew update
$ brew install carthage</pre></div>

<p>To integrate WeCards Sign-In into your Xcode project using Carthage, specify it in your <code>Cartfile</code>:</p>
<pre lang="ogdl"><code>github "patelnirav48/WeCards" ~&gt; 1.0
</code></pre>

<p>Run <code>carthage update</code> to build the framework and drag the built <code>WeCardsSignIn.framework</code> into your Xcode project.</p>


<h3>CocoaPods</h3>

<p><a href="https://cocoapods.org/">CocoaPods</a> is a dependency manager for Cocoa projects. You can install it with the following command:</p>

<div class="highlight highlight-source-shell"><pre>$ gem install cocoapods</pre></div>

<p>To integrate WeCards Sign-In into your Xcode project using CocoaPods, specify it in your <code>Podfile</code>:</p>
<pre lang="ogdl"><code>source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

<p>target '<Your Target Name>' do
    pod 'WeCardsSignIn', :path => '../WeCardsSignIn'
    pod 'Alamofire', '~> 4.7'
end</p></code></pre>

<p>Then, run the following command:</p>
<div class="highlight highlight-source-shell"><pre>$ pod install</pre></div>

# .plist Entries

In order for your app to signin with WeCards, you'll need to ad these plist entries:

    <key>WeCardsAppID</key>
	<string>#WECARDS_APP_ID#</string>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>wecards</string>
	</array>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLName</key>
			<string>#BUNDLE_IDENTIFIER#</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>wecards#WECARDS_APP_ID#</string>
			</array>
		</dict>
	</array>
	
# Configurations

<h3>In your App Delegate,</h3>

    import WeCardsSignIn
       
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WCSignIn.sharedInstance().application(app, open: url, options: options)
    }

<h3>In your View Controller,</h3>

To initiate, add the following code to an appropriate view controller:

    import WeCardsSignIn
    
    class ViewController: UIViewController, WeCardsSignInDelegate {

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        
            WCSignIn.sharedInstance().delegate = self
            WCSignIn.sharedInstance().presentViewController(viewController: self)
        }
    }
    
When the authentication is complete, you will get a callback via the WeCardsSignInDelegate protocol:

    func onAuthenticationSuccessful(dictionary: NSDictionary) {
        print("Successful Authentication!")
    }
    
    func onAuthenticationFail(message: String) {
        print("Authentication Failed!")
    }
    
    func onSignOutSuccessful(dictionary: NSDictionary) {
        print("Signout successfully")
    }





	
