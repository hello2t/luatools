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

#if defined(WIN32) && !defined(__cplusplus)

#define inline __inline

#endif



#if LUA_VERSION_NUM < 502

#define luaL_checkinteger luaL_checknumber
#define lua_rawlen lua_objlen
#define lua_pushinteger lua_pushnumber
#endif


static const int ADD=2;
static const int DEL=-2;


static int _newBuf(lua_State *L){
    size_t l;
    const char * mapdata = luaL_checklstring(L, 1, &l);
    bitBuf * data = bitBuf_newBuf((uint32_t)l, (uint8_t *)mapdata);
    
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
    double len = luaL_checkinteger(L, 1);
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
    int32_t data2 = data+DEL;
    // printf("read %d\n", data2);
    lua_pushnumber(L, data2);
    return 1;
}

static int _writeInt(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    int32_t data = luaL_checkinteger(L, 2) + ADD;
    // printf("write %zu\n", luaL_checkinteger(L, 2));
    elias_delta_encode((uint32_t)data, bit);
    return 0;
}

static int _readUtf8(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    char * str = elias_delta_decode_utf8(bit);
    size_t len = strlen(str);
    lua_pushlstring(L, str,len);
    free(str);
    return 1;
}

static int _readIntArray(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);
    uint32_t data =  elias_delta_decode(bit);
    uint32_t i;
    lua_createtable(L,data,0);
    
    for (i=0; i<data;i++)
    {
        lua_pushinteger(L,elias_delta_decode(bit)+DEL);
        lua_rawseti(L,-2,i+1);
    }
    return 1;
}

static int _writeIntArray(lua_State *L){
    bitBuf * bit = _to_bitBuf(L);

    uint32_t size;
    size=(uint32_t)lua_rawlen(L,-1);
    elias_delta_encode(size,bit);
    int32_t data ;
    int i;
    for (i = 0; i < size; ++i)
    {
        lua_rawgeti(L,-1,i+1);
        data = luaL_checkinteger(L,-1)+ADD;
        elias_delta_encode(data,bit);
        lua_pop(L,1);
    }
    lua_pop(L,2);
    return 0;
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
        {"readIntArray", _readIntArray},
        {"writeIntArray", _writeIntArray},
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