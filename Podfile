# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

project 'Movies.xcodeproj'
workspace 'Movies.xcworkspace'
use_frameworks!

target 'Movies' do
  # Comment the next line if you don't want to use dynamic frameworks

  # Pods for Movies

    pod 'Kingfisher', '~> 6.3'
    pod 'RxSwift', '~> 6.2'
    pod 'RxCocoa', '~> 6.2'

  target 'MoviesTests' do
    inherit! :search_paths
    # Pods for testing

    pod 'RxBlocking', '~> 6.2'
    pod 'RxTest', '~> 6.2'

  end

  target 'MoviesUITests' do
    # Pods for testing
  end

end

target 'ImdbAPI' do
  project 'MoviesAPI/MoviesAPI/ImdbAPI.xcodeproj'
  pod 'RxSwift', '~> 6.2'
  pod 'RxCocoa', '~> 6.2'
  pod 'Kingfisher', '~> 6.3'
end

target 'Utils' do
  project 'Utils/Utils/Utils.xcodeproj'
  pod 'RxSwift', '~> 6.2'
  pod 'RxCocoa', '~> 6.2'
end
