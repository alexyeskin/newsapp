platform :ios, '11.0'
use_frameworks!

inhibit_all_warnings!

def swinject_pods
    pod 'Swinject', '2.5.0'
end

def helpers_pods
    pod 'R.swift', '5.0.0'
    pod 'SwiftyJSON', '4.2.0'
    pod 'FeedKit', '9.0'
    pod 'Nuke', '8.3.1'
end

target 'NewsApp' do
        
    swinject_pods
    helpers_pods
    
end

target 'NewsAppTests' do
        
    swinject_pods
    helpers_pods
    
end

post_install do |installer|
 # This removes the warning about swift conversion, hopefuly forever!
 installer.pods_project.root_object.attributes[‘LastSwiftMigration'] = 9999
 installer.pods_project.root_object.attributes[‘LastSwiftUpdateCheck'] = 9999
 installer.pods_project.root_object.attributes[‘LastUpgradeCheck'] = 9999
end