Pod::Spec.new do |s|
  s.name         = "Journal"
  s.version      = "0.9.0"
  s.summary      = "The modern way of logging on iOS."
  s.description  = <<-DESC
                   Journal is an iOS logging library with a desktop client application to help
                   seeing only the relevant loglines.
                   DESC
  s.homepage     = "https://github.com/holloandris/Journal"
  s.license      = "MIT"
  s.author       = { "Andras Hollo" => "hollo.andris@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/holloandris/Journal.git", :tag => "v#{s.version}" }
  s.source_files = "Journal/**/*.swift"
  s.ios.deployment_target = "10.0"
end
