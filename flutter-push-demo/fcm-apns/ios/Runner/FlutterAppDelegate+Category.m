//
//  FlutterAppDelegate+Category.m
//  Runner
//
//  Created by 杜洁鹏 on 2024/12/4.
//

#import "FlutterAppDelegate+Category.h"
#import <HyphenateChat/HyphenateChat.h>

@implementation FlutterAppDelegate (Category)
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [EMClient.sharedClient applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [EMClient.sharedClient applicationWillEnterForeground:application];
}
@end
