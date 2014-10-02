//
//  LGLuaBridge.m
//  swift-engine
//
//  Created by Luke Godfrey on 10/1/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

#import "LGLuaBridge.h"
#import "lua.hpp"

#import <SpriteKit/SpriteKit.h>
#import <LGSwiftEngine/LGSwiftEngine-Swift.h>

@interface LGLuaBridge ()
{
	lua_State *luaState;
}
- (void) initialize;

@end

@implementation LGLuaBridge

+ (LGLuaBridge *)sharedBridge
{
	static LGLuaBridge *bridge;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		bridge = [[LGLuaBridge alloc] init];
		[bridge initialize];
	});
	
	return bridge;
}

- (void)runScript:(NSString *)script
{
	int error;
	
	if([[script pathExtension] isEqualToString:@"lua"])
	{
		NSString *scriptFile = [[NSBundle bundleForClass:self.class] pathForResource:script ofType:nil];
		error = luaL_dofile(luaState, [scriptFile cStringUsingEncoding:NSUTF8StringEncoding]);
	}
	else
	{
		error = luaL_dostring(luaState, [script cStringUsingEncoding:NSUTF8StringEncoding]);
	}
	
	if(error)
	{
		NSLog(@"An error occurred while running Lua script: %s", lua_tostring(luaState, -1));
	}
}

- (void)initialize
{
	luaState = luaL_newstate();
	luaL_openlibs(luaState);
	
	luaL_newlib(luaState, gamelib);
	lua_setglobal(luaState, gamelib_name);
	
	[self runScript:@"print('Lua bridge initialized!');"];
}

#pragma mark Game Library

static int game_getProp(lua_State *L)
{
	luaL_argcheck(L, lua_isnumber(L, 1), 1, "Must be a number!");
	luaL_argcheck(L, lua_isstring(L, 2), 2, "Must be a string!");
	luaL_argcheck(L, lua_isstring(L, 3), 3, "Must be a string!");
	
	int entity			= [[NSNumber numberWithInteger:lua_tonumber(L, 1)] intValue];
	NSString *component	= [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];
	NSString *prop		= [NSString stringWithCString:lua_tostring(L, 3) encoding:NSUTF8StringEncoding];
	
	LGJSON *json = [LGGameLibrary getProp:prop entity:entity component:component];
	
	if(json == nil || json.isNil)
	{
		lua_pushnil(L);
	}
	else if(json.stringValue != nil)
	{
		lua_pushstring(L, [json.stringValue cStringUsingEncoding:NSUTF8StringEncoding]);
	}
	else if(json.numberValue != nil)
	{
		lua_pushnumber(L, json.numberValue.doubleValue);
	}
	else
	{
		lua_pushnil(L);
	}
	
	return 1;
}

static int game_setProp(lua_State *L)
{
	luaL_argcheck(L, lua_isnumber(L, 1), 1, "Must be a number!");
	luaL_argcheck(L, lua_isstring(L, 2), 2, "Must be a string!");
	luaL_argcheck(L, lua_isstring(L, 3), 3, "Must be a string!");
	
	int entity			= [[NSNumber numberWithInt:lua_tonumber(L, 1)] intValue];
	NSString *component	= [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];
	NSString *prop		= [NSString stringWithCString:lua_tostring(L, 3) encoding:NSUTF8StringEncoding];
	LGJSON *value		= [[LGJSON alloc] init];
	
	if(lua_type(L, 4) == LUA_TSTRING)
	{
		[value setValue:[NSString stringWithCString:lua_tostring(L, 4) encoding:NSUTF8StringEncoding]];
	}
	else if(lua_type(L, 4) == LUA_TNUMBER)
	{
		[value setValue:[NSNumber numberWithDouble:lua_tonumber(L, 4)]];
	}
	
	[LGGameLibrary setProp:prop entity:entity component:component value:value];
	
	return 0;
}

static int game_getEntityId(lua_State *L)
{
	luaL_argcheck(L, lua_isstring(L, 1), 1, "Must be a string!");
	
	NSString *name		= [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];
	NSNumber *entity	= [LGGameLibrary getEntityId:name];
	
	if(entity != nil)
	{
		lua_pushnumber(L, [entity intValue]);
	}
	else
	{
		lua_pushnil(L);
	}
	
	return 1;
}

static const char *gamelib_name = "game";
static const luaL_Reg gamelib[] =
{
	{ "getProp",		game_getProp },
	{ "setProp",		game_setProp },
	{ "getEntityId",	game_getEntityId },
	{ NULL,				NULL }
};

@end
