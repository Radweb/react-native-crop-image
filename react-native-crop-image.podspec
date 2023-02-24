Pod::Spec.new do |s|
  s.name         = "react-native-crop-image"
  s.version      = "4.0.0"
  s.summary      = "Crop an image. Super Simple Stuff."
  s.description  = <<-DESC
    Crops an image
                   DESC

  s.homepage     = "https://github.com/Radweb/react-native-crop-image"
  s.license      = "Apache-2.0"
  s.author             = "Radweb"
  s.source       = { :git => "https://github.com/Radweb/react-native-crop-image.git", :tag => "#{s.version}" }
  s.source_files  = "ios"
  s.dependency "React"
  
  s.platform     = :ios, "8.0"
end
