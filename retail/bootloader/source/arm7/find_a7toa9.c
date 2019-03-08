//#include <string.h> // memcmp
#include <stddef.h> // NULL
#include <nds/ndstypes.h>
//#include <limits.h>
#include "common.h"

u32* findOffset(const u32* start, u32 dataLen, const u32* find, u32 findLen) {
	arm9_findOff = start;
	arm9_findDataLen = dataLen;
	for (u32 i = 0; i < findLen; i++) {
		arm9_codeSig[i] = find[i];
	}
	arm9_findLen = findLen;
	arm9_stateFlag = ARM9_FIND;
	while (arm9_stateFlag != ARM9_READY);
	return arm9_foundOff;
};
u32* findOffsetBackwards(const u32* start, u32 dataLen, const u32* find, u32 findLen) {
	arm9_findOff = start;
	arm9_findDataLen = dataLen;
	for (u32 i = 0; i < findLen; i++) {
		arm9_codeSig[i] = find[i];
	}
	arm9_findLen = findLen;
	arm9_stateFlag = ARM9_FINDBACK;
	while (arm9_stateFlag != ARM9_READY);
	return arm9_foundOff;
};
u16* findOffsetThumb(const u16* start, u32 dataLen, const u16* find, u32 findLen) {
	arm9_findOffThumb = start;
	arm9_findDataLen = dataLen;
	for (u32 i = 0; i < findLen; i++) {
		arm9_codeSigThumb[i] = find[i];
	}
	arm9_findLen = findLen;
	arm9_stateFlag = ARM9_FINDTHUMB;
	while (arm9_stateFlag != ARM9_READY);
	return arm9_foundOffThumb;
};
u16* findOffsetBackwardsThumb(const u16* start, u32 dataLen, const u16* find, u32 findLen) {
	arm9_findOffThumb = start;
	arm9_findDataLen = dataLen;
	for (u32 i = 0; i < findLen; i++) {
		arm9_codeSigThumb[i] = find[i];
	}
	arm9_findLen = findLen;
	arm9_stateFlag = ARM9_FINDBACKTHUMB;
	while (arm9_stateFlag != ARM9_READY);
	return arm9_foundOffThumb;
};
