Pod::Spec.new do |s|
          #1.
          s.name               = "WeCardsSignIn"
          #2.
          s.version            = "1.0.0"
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
          s.source_files     = "WeCardsSignIn", "WeCardsSignIn/**/*.{h}"
          s.resources = "WeCardsSignIn/WeCardsResources.bundle"
          s.swift_version = "4.2"
          s.requires_arc = true

    end
