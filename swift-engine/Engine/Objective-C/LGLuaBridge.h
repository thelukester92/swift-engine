//
//  LGLuaBridge.h
//  swift-engine
//
//  Created by Luke Godfrey on 10/1/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGGame;

@interface LGLuaBridge : NSObject

+ (LGLuaBridge *)sharedBridge;
- (void)runScript: (NSString *)script;

@end
