//
//  main.m
//  luxshare
//
//  Created by 黄振 on 2020/6/22.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <signal.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        sigaction(SIGPIPE, &(struct sigaction){SIG_IGN}, NULL);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
