#ifndef NDS_HEADER_H
#define NDS_HEADER_H

#include <string.h>
#include <nds/memory.h> // tNDSHeader

const char* getRomTid(const tNDSHeader* ndsHeader);
const char* a9_getRomTid(const tNDSHeader* ndsHeader);

#endif // NDS_HEADER_H
