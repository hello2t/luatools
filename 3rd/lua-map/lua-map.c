//
//  lua-map.c
//  coe
//
//  Created by zj on 15/6/24.
//
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lua.h"
#include "lauxlib.h"

#include "lua-map.h"
#include "libquantocode.h"

static int _newBuf(lua_State *L){
    size_t l;
    const char * mapdata = luaL_checklstring(L, 1, &l);
    bitBuf * data = bitBuf_newBuf((uint8_t)l, (uint8_t *)mapdata);
    
    bitBuf **datap = (bitBuf**)lua_newuserdata(L, sizeof(bitBuf*));
    *datap = data;
    lua_pushvalue(L, lua_upvalueindex(1));
    lua_setmetatable(L, -2);
    return 1;
}

static inline bitBuf * _to_bitBuf(lua_State *L){
    bitBuf ** bit = lua_touserdata(L, 1);
    if (bit==NULL) {
        luaL_error(L, "first arg is bitBuf");
    }
    return *bit;
}

static int _new(lua_State *L){
    double len = luaL_checknumber(L, 1);
    bitBuf * data = bitBuf_new(len);
    
    bitBuf **datap = (bitBuf**)lua_newuserdata(L, sizeof(bitBuf*));
    *datap = data;
    lua_pushvalue(L, lua_upvalueindex(1));
    lua_setmetatable(L, -2);
    return 1;
}

static int _del(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    bitBuf_delete(bit);
    return 0;
}

static int _readInt(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    uint32_t data =  elias_delta_decode(bit);
    lua_pushnumber(L, data);
    return 1;
}

static int _writeInt(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    uint32_t data = luaL_checknumber(L, 2);
    elias_delta_encode(data, bit);
    return 0;
}

static int _readUtf8(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    char * str = elias_delta_decode_utf8(bit);
    lua_pushstring(L, str);
    free(str);
    return 1;
}




static int _writeUtf8(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    const char * str = luaL_checkstring(L, 2);
    elias_delta_encode_utf8(str, bit);
    return 0;
}

static int _getString(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    size_t len =(size_t)(bit->pos>>3);
    char * str = malloc(len);
    memset(str, 0, len);
    memcpy(str, bit->buf, len);
    lua_pushlstring(L, str, len);
    free(str);
    return 1;
}

int luaopen_map(lua_State *L) {
    
    luaL_Reg l[] = {
        {"readInt", _readInt},
        {"readString",_readUtf8},
        {"writeString",_writeUtf8},
        {"writeInt", _writeInt},
        {"newBuf", _newBuf},
        {"getString", _getString},
        {"new", _new},
        {"del", _del},
        {NULL, NULL}
    };
#if LUA_VERSION_NUM > 501 && !defined(LUA_COMPAT_MODULE)
    lua_createtable(L, 0, 2);
    luaL_newlib(L, l);
#else
    luaL_openlib(L,"map",l,0);
#endif
    
    
    return 1;
}