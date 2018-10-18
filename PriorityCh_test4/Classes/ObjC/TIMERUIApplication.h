//
//  TIMERUIApplication.h
//  PriorityChoice_v25
//
//  Created by Manulife Philippines on 11/21/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import <UIKit/UIKit.h>

//the length of time before your application "times out". This number actually represents seconds, so we'll have to multiple it by 60 in the .m file
#define kApplicationTimeoutInMinutes 15
#define kApplicationTimeoutWarningInMinutes1 4
#define kApplicationTimeoutWarningInMinutes2 3
#define kApplicationTimeoutWarningInMinutes3 1

//the notification your AppDelegate needs to watch for in order to know that it has indeed "timed out"
#define kApplicationDidTimeoutNotification @"AppTimeOut"
#define kApplicationDidTimeoutWarning @"You will be automatically logged out after one minute.\nPlease tap \"OK\" to extend your session."
	
@interface TIMERUIApplication : UIApplication
{
    NSTimer     *myidleTimer;
    NSTimer     *myidleTimerWarning1;
    NSTimer     *myidleTimerWarning2;
    NSTimer     *myidleTimerWarning3;
}

-(void)resetIdleTimer;

@end
