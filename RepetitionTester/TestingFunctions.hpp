#pragma once

#include <cstdio>

#include "RepetitionTester.hpp"

#include <windows.h>
#include <fcntl.h>
#include <io.h>

struct buffer
{
    size_t Count;
    uint8_t *Data;
};

#define CONSTANT_STRING(String) {sizeof(String) - 1, (uint8_t *)(String)}

static bool IsInBounds(buffer Source, uint64_t At)
{
    bool Result = (At < Source.Count);
    return Result;
}

static bool AreEqual(buffer A, buffer B)
{
    if(A.Count != B.Count)
    {
        return false;
    }
    
    for(uint64_t Index = 0; Index < A.Count; ++Index)
    {
        if(A.Data[Index] != B.Data[Index])
        {
            return false;
        }
    }
    
    return true;
}

static buffer AllocateBuffer(size_t Count)
{
    buffer Result = {};
    Result.Data = (uint8_t *)malloc(Count);
    if(Result.Data)
    {
        Result.Count = Count;
    }
    else
    {
        fprintf(stderr, "ERROR: Unable to allocate %llu bytes.\n", Count);
    }
    
    return Result;
}

static void FreeBuffer(buffer *Buffer)
{
    if(Buffer->Data)
    {
        free(Buffer->Data);
    }
    *Buffer = {};
}

struct read_parameters
{
    buffer Dest;
    char const *FileName;
};

typedef void read_overhead_test_func(RepetitionTester *Tester, read_parameters *Params);

static void ReadViaFRead(RepetitionTester *Tester, read_parameters *Params)
{
    while(!Tester->is_done())
    {
        FILE *File = fopen(Params->FileName, "rb");
        if(File)
        {
            buffer DestBuffer = Params->Dest;

            Tester->start_iter();
            size_t Result = fread(DestBuffer.Data, DestBuffer.Count, 1, File);
            Tester->end_iter();

            if(Result == 1)
            {
                Tester->set_or_assert_bytes_count(DestBuffer.Count);
            }
            else
            {
                Tester->error("fread failed");
            }

            fclose(File);
        }
        else
        {
            Tester->error("fopen failed");
        }
    }
}

static void ReadViaRead(RepetitionTester *Tester, read_parameters *Params)
{
    while(!Tester->is_done())
    {
        int File = _open(Params->FileName, _O_BINARY|_O_RDONLY);
        if(File != -1)
        {
            buffer DestBuffer = Params->Dest;

            uint8_t *Dest = DestBuffer.Data;
            uint64_t SizeRemaining = DestBuffer.Count;
            while(SizeRemaining)
            {
                uint32_t ReadSize = INT_MAX;
                if((uint64_t)ReadSize > SizeRemaining)
                {
                    ReadSize = (uint32_t)SizeRemaining;
                }

                Tester->start_iter();
                int Result = _read(File, Dest, ReadSize);
                Tester->end_iter();

                if(Result == (int)ReadSize)
                {
                    Tester->set_or_assert_bytes_count(DestBuffer.Count);
                }
                else
                {
                    Tester->error("_read failed");
                    break;
                }

                SizeRemaining -= ReadSize;
                Dest += ReadSize;
            }

            _close(File);
        }
        else
        {
            Tester->error("_open failed");
        }
    }
}

static void ReadViaReadFile(RepetitionTester *Tester, read_parameters *Params)
{
    while(!Tester->is_done())
    {
        HANDLE File = CreateFileA(Params->FileName, GENERIC_READ, FILE_SHARE_READ|FILE_SHARE_WRITE, 0,
                                  OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
        if(File != INVALID_HANDLE_VALUE)
        {
            buffer DestBuffer = Params->Dest;

            uint64_t SizeRemaining = Params->Dest.Count;
            uint8_t *Dest = (uint8_t *)DestBuffer.Data;
            while(SizeRemaining)
            {
                uint32_t ReadSize = (uint32_t)-1;
                if((uint64_t)ReadSize > SizeRemaining)
                {
                    ReadSize = (uint32_t)SizeRemaining;
                }

                DWORD BytesRead = 0;
                Tester->start_iter();
                BOOL Result = ReadFile(File, Dest, ReadSize, &BytesRead, 0);
                Tester->end_iter();

                if(Result && (BytesRead == ReadSize))
                {
                    Tester->set_or_assert_bytes_count(DestBuffer.Count);
                }
                else
                {
                    Tester->error("ReadFile failed");
                }

                SizeRemaining -= ReadSize;
                Dest += ReadSize;
            }

            CloseHandle(File);
        }
        else
        {
            Tester->error("CreateFileA failed");
        }
    }
}