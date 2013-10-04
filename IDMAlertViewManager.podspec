Pod::Spec.new do |s|
  s.name         = "IDMAlertViewManager"
  s.version      = "1.0"
  s.summary      = "An UIAlertView manager to handle different priorities alerts. Also terminates the problem of having multiple alerts being displayed above one another."
  s.homepage     = "http://ideaismobile.github.io/IDMAlertViewManager/"

  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Ideais Mobile" => "mobile@ideais.com.br" }
  s.source       = { 
    :git => "git@github.com:ideaismobile/IDMAlertViewManager.git", 
    :tag => "1.0"
  }

  s.platform     = :ios, '6.1'
  
  s.source_files = 'Classes/*.{h,m}'
  
  s.requires_arc = true
end