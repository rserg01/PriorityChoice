//
//  main.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/26/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"	
#import "TIMERUIApplication.h"

int main(int argc, char *argv[])
{
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, NSStringFromClass([TIMERUIApplication class]), NSStringFromClass([AppDelegate class]));
    }
}
