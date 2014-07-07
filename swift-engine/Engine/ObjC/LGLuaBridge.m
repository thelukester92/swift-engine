//
//  LGLuaBridge.m
//  Engine
//
//  Created by Luke Godfrey on 5/27/14.
//  Copyright (c) 2014 Luke Godfrey. All rights reserved.
//

#import "LGLuaBridge.h"
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

@interface LGLuaBridge ()
{
	lua_State *luaState;
}
@end

@implementation LGLuaBridge

#pragma mark LGLuaBridge Methods

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

- (void)runScript:(NSString *)script withSelf:(id)object andOtherObject:(id)other
{
	if([script length] > 0)
	{
		int error;
		
		if(object)
		{
			lua_pushlightuserdata(luaState, (__bridge void *)object);
			lua_setglobal(luaState, "self");
		}
		
		if(other)
		{
			lua_pushlightuserdata(luaState, (__bridge void *)other);
			lua_setglobal(luaState, "other");
		}
		
		if([[script pathExtension] isEqualToString:@"lua"])
		{
			NSString *scriptFile = [[NSBundle mainBundle] pathForResource:script ofType:nil];
			error = luaL_dofile(luaState, [scriptFile cStringUsingEncoding:[NSString defaultCStringEncoding]]);
		}
		else
		{
			error = luaL_dostring(luaState, [script cStringUsingEncoding:[NSString defaultCStringEncoding]]);
		}
		
		if(error)
		{
			NSLog(@"An error occurred while running a Lua script.\nError: %s\nObject: %@\nScript: %@", lua_tostring(luaState, -1), object, script);
		}
	}
}

- (void)runScript:(NSString *)script withSelf:(id)object
{
	[self runScript:script withSelf:object andOtherObject:nil];
}

- (void)runScript:(NSString *)script
{
	[self runScript:script withSelf:nil andOtherObject:nil];
}

- (void)initialize
{
	luaState = luaL_newstate();
	luaL_openlibs(luaState);
	
	luaL_newlib(luaState, gamelib);
	lua_setglobal(luaState, gamelib_name);
	
	[self runScript:@"LGLuaBridge.lua"];
}

#pragma mark Bridge Methods

static id toid(lua_State *L, int i)
{
	id value = nil;
	
	if(lua_isstring(L, i))
	{
		value = [NSString stringWithCString:lua_tostring(L, i) encoding:[NSString defaultCStringEncoding]];
	}
	else if(lua_isnumber(L, i))
	{
		value = [NSNumber numberWithFloat:lua_tonumber(L, i)];
	}
	else
	{
		NSLog(@"Invalid type!");
	}
	
	return value;
}

static int pushid(lua_State *L, id value)
{
	if([value isKindOfClass:[NSString class]])
	{
		lua_pushstring(L, [value cStringUsingEncoding:[NSString defaultCStringEncoding]]);
		return 1;
	}
	else if([value isKindOfClass:[NSNumber class]])
	{
		lua_pushnumber(L, [value floatValue]);
		return 1;
	}
	
	lua_pushnil(L);
	return 1;
}

#pragma mark gamelib

// game.tween(lightuserdata object, string property, value[, options])
static int game_tween(lua_State *L)
{
	// TODO: Implement this
	
	id object;
	BOOL isUserdata = NO;
	
	if(lua_isuserdata(L, 1))
	{
		object = (__bridge id)lua_touserdata(L, 1);
		isUserdata = YES;
	}
	else if(lua_istable(L, 1))
	{
		lua_pushstring(L, "pointer");
		lua_gettable(L, 1);
		
		if(lua_isuserdata(L, -1))
		{
			object = (__bridge id)lua_touserdata(L, -1);
			isUserdata = YES;
		}
	}
	
	luaL_argcheck(L, isUserdata, 1, "Must be a pointer or a table!");
	luaL_argcheck(L, lua_isstring(L, 2), 2, "Must be a string!");
	luaL_argcheck(L, !lua_isnil(L, 3), 3, "Must not be nil!");
	
	NSString *property	= [NSString stringWithCString:lua_tostring(L, 2) encoding:[NSString defaultCStringEncoding]];
	double value		= [toid(L, 3) doubleValue];
	
	NSLog(@"Tweening %@ with value %0.2f", property, value);
	// [LGTweener tweenWithTarget:object property:property value:value seconds:0.5];

	return 0;
}

// game.getEntity(string id)
static int game_getEntity(lua_State *L)
{
	luaL_argcheck(L, lua_isstring(L, 1), 1, "Must be a string!");
	/*
	LGEntity *entity = [[[LGEngine sharedEngine] currentScene] entityWithTag:[NSString stringWithCString:lua_tostring(L, 1) encoding:[NSString defaultCStringEncoding]]];
	
	if(entity)
	{
		lua_pushlightuserdata(L, (__bridge void *)entity);
	}
	else
	{
		*/lua_pushnil(L);
	/*}*/
	
	return 1;
}

// game.getComponent(lightuserdata object, string component)
static int game_getComponent(lua_State *L)
{
	luaL_argcheck(L, lua_isuserdata(L, 1), 1, "Must be a pointer!");
	luaL_argcheck(L, lua_isstring(L, 2), 2, "Must be a string!");
	
	/*id object				= (__bridge id)lua_touserdata(L, 1);
	NSString *type			= [NSString stringWithCString:lua_tostring(L, 2) encoding:[NSString defaultCStringEncoding]];
	LGComponent *component	= [object componentOfType:type];
	
	if(component != nil)
	{
		lua_pushlightuserdata(L, (__bridge void *)component);
	}
	else
	{
		*/lua_pushnil(L);
	/*}*/
	
	return 1;
}

// game.getPointer(lightuserdata object, string property)
static int game_getPointer(lua_State *L)
{
	luaL_argcheck(L, lua_isuserdata(L, 1), 1, "Must be a pointer!");
	luaL_argcheck(L, lua_isstring(L, 2), 2, "Must be a string!");
	
	id object			= (__bridge id)lua_touserdata(L, 1);
	NSString *property	= [NSString stringWithCString:lua_tostring(L, 2) encoding:[NSString defaultCStringEncoding]];
	
	lua_pushlightuserdata(L, (__bridge void *)[object valueForKey:property]);
	
	return 1;
}

// game.getValue(lightuserdata object, string property)
static int game_getValue(lua_State *L)
{
	luaL_argcheck(L, lua_isuserdata(L, 1), 1, "Must be a pointer!");
	luaL_argcheck(L, lua_isstring(L, 2), 2, "Must be a string!");
	
	id object			= (__bridge id)lua_touserdata(L, 1);
	NSString *property	= [NSString stringWithCString:lua_tostring(L, 2) encoding:[NSString defaultCStringEncoding]];
	id value			= [object valueForKey:property];
	
	return pushid(L, value);
}

// game.setValue(lightuserdata object, string property, value)
static int game_setValue(lua_State *L)
{
	luaL_argcheck(L, lua_isuserdata(L, 1), 1, "Must be a pointer!");
	luaL_argcheck(L, lua_isstring(L, 2), 2, "Must be a string!");
	luaL_argcheck(L, !lua_isnil(L, 3), 3, "Must not be nil!");
	
	id object			= (__bridge id)lua_touserdata(L, 1);
	NSString *property	= [NSString stringWithCString:lua_tostring(L, 2) encoding:[NSString defaultCStringEncoding]];
	id value			= toid(L, 3);
	
	[object setValue:value forKey:property];
	
	return 0;
}

static const char *gamelib_name = "game";
static const luaL_Reg gamelib[] =
{
	{ "tween",			game_tween },
	{ "getEntity",		game_getEntity },
	{ "getComponent",	game_getComponent },
	{ "getPointer",		game_getPointer },
	{ "getValue",		game_getValue },
	{ "setValue",		game_setValue },
	{ NULL, NULL }
};

@end