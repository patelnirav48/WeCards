Pod::Spec.new do |s|
          #1.
          s.name               = "WeCardsSignIn"
          #2.
          s.version            = "1.5"
          #3.  
          s.summary         = "The WeCards Sign-In iOS quickstart demonstrates how to authenticate people with their WeCards credentials."
          #4.
          s.homepage        = "http://www.we.cards"
          #5.
          s.license              = "MIT"
          #6.
          s.author               = "Nirav Patel"
          #7.
          s.platform            = :ios, "10.0"
          #8.
          s.source              = { :git => "https://github.com/patelnirav48/WeCards.git", :tag => "1.0" }
          #9.

          s.source_files     = "WeCardsSignIn/**/*.{h,swift}"
	  s.resources        = "WeCardsSignIn/*.{bundle,storyboard}"
	  
          #s.resource_bundles = "WeCardsSignIn/*.{bundle}"
          #s.exclude_files = "WeCardsSignIn/**/*.{framework}"

          s.dependency 'Alamofire'
         
          #s.frameworks = 'WeCardsSignIn'
	  #s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '/Applications/Xcode.app/Contents/Developer/Library/Frameworks' }
	  
          s.vendored_frameworks = 'Alamofire.framework'

          s.swift_version = "4.2"
    end
