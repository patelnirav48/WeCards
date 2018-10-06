# WeCards
The WeCards Sign-In iOS quick start demonstrates how to authenticate people with their WeCards credentials.

# Requirements

    iOS 8.0+ / macOS 10.10+
    Xcode 10.0+
    Swift 4.2+
    
# Installation

<h3>Carthage</h3>

<p><a href="https://github.com/Carthage/Carthage">Carthage</a> is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.</p>

<p>You can install Carthage with <a href="https://brew.sh/" rel="nofollow">Homebrew</a> using the following command:</p>
<div class="highlight highlight-source-shell"><pre>$ brew update
$ brew install carthage</pre></div>

<p>To integrate Alamofire into your Xcode project using Carthage, specify it in your <code>Cartfile</code>:</p>
<pre lang="ogdl"><code>github "patelnirav48/WeCards" ~&gt; 1.0
</code></pre>

<p>Run <code>carthage update</code> to build the framework and drag the built <code>WeCardsSignIn.framework</code> into your Xcode project.</p>

# .Plist Entries

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
	
# Initialization

In your App Delegate,

       import WeCardsSignIn
       
       func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
          return WCSignIn.sharedInstance().application(app, open: url, options: options)
       }






	
