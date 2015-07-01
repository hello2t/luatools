/*
 *  Copyright (c) 2009 Rodrigo Fonseca <rodrigo.fonseca@gmail.com>
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 *
 *  Author: Rodrigo Fonseca <rodrigo.fonseca@gmail.com>
 *
 */


#ifndef _LIBQUANTOCODE_H
#define _LIBQUANTOCODE_H

#include <stdint.h>

typedef uint8_t bool;
#define FALSE 0
#define TRUE 1

/***************** A BitBuffer *****************/
typedef struct {
    uint32_t size; //size in bytes
    uint32_t pos;  //position in bits where to write next bit
    uint32_t rpos; //position in bits where to read next bit
    uint8_t buf[];
} bitBuf;

bitBuf* bitBuf_new(uint32_t size);
bitBuf* bitBuf_newBuf(uint32_t size,uint8_t buf[]);


void bitBuf_delete(bitBuf* buf);

void bitBuf_clear(bitBuf* buf);

void bitBuf_setReadPos(bitBuf* buf,uint32_t pos);
void bitBuf_resetReadPos(bitBuf* buf);
uint32_t bitBuf_getReadPos(bitBuf* buf);

/** Return the length of the bitBuf in bytes */
uint32_t bitBuf_length(bitBuf* buf);

bool bitBuf_putBit(bitBuf* buf, bool bit);
int bitBuf_getNextBit(bitBuf* buf);

void bitBuf_print(bitBuf* buf);

/************* 32-bit Elias Gamma Codec ***************/
/* encode */
void elias_gamma_encode(uint32_t b, bitBuf* buf);

void elias_delta_encode_utf8(const char* str,bitBuf* buf);

/* Decode the next elias_gamma integer from the buffer.
 * Assumes that an elias_gamma encoded integer begins in
 * buf->rpos */
uint32_t elias_gamma_decode(bitBuf *buf);

char * elias_delta_decode_utf8(bitBuf* buf);

/************ 32-bit Elias Delta Codec ***************/
/* Elias Delta encodes the length portion of the elias
 * gamma code using elias gamma */
void elias_delta_encode(uint32_t b, bitBuf* buf);
uint32_t elias_delta_decode(bitBuf *buf);
/************ 8-bit Move To Front Codec **************/
typedef struct {
    uint8_t order[256];
    uint8_t h;
} mtf_encoder;


void mtf_init(mtf_encoder* mtf);
uint8_t mtf_encode(mtf_encoder* mtf, uint8_t b);
uint8_t mtf_decode(mtf_encoder* mtf, uint8_t b);

#endif
