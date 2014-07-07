//
//  LGLuaBridge.h
//  Engine
//
//  Created by Luke Godfrey on 5/27/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGLuaBridge : NSObject

+ (LGLuaBridge *)sharedBridge;

- (void)runScript:(NSString *)script withSelf:(id)object andOtherObject:(id)other;
- (void)runScript:(NSString *)script withSelf:(id)object;
- (void)runScript:(NSString *)script;
- (void)initialize;

@end