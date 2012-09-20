// --------------------------------------------------------------------------------------------------------------------------------
// UIPasteboardAudio
// Copyright (c) 2010 INTUA s.à.r.l.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without
// limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
// THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// --------------------------------------------------------------------------------------------------------------------------------
//
//  CUPasteboard.m
//  Loopseque
//
//  Created by Pavel Litvinenko on 22.04.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//

#import "CUPasteboard.h"
#import <UIKit/UIPasteboard.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "NSDictionary+Archive.h"
#import "NSDictionary+NSData.h"

#define kDefaultLocalPasteboardName @"Loopseque Pasteboard"

// C-fonction for appending metadata information to a string
static void AddInfoToString(const void *_key, const void *_value, void *_context) {
	NSMutableString* fmt = (NSMutableString *) _context;
	NSString* key = (NSString *) _key;
	NSString* val = (NSString *) _value;
	
	[fmt appendFormat:@"\n%@: %@", key, val];
}

@interface CUPasteboard(hidden)
- (void)copyObject:(id)obj toClipboard:(UIPasteboard*)board;
- (void)copyAudio:(NSString*)srcPath toClipboard:(UIPasteboard*)board;
- (void)copyDictionary:(NSDictionary*)dictionary toClipboard:(UIPasteboard*)board;
- (NSArray*)dataItemsForType:(NSString*)type fromPasteboard:(UIPasteboard*)board;
- (NSDictionary*)dictionaryFromClipBoard:(UIPasteboard*)board;
- (NSString*)audioFromClipBoard:(UIPasteboard*)board;
@end

@implementation CUPasteboard

+ (void)cleanLocalPasteboard {
    [UIPasteboard removePasteboardWithName:kDefaultLocalPasteboardName];
}

#pragma mark Copying to clipboard

+ (void)copy:(id)obj {
    CUPasteboard *pasteboard = [[[CUPasteboard alloc] init] autorelease];
    [pasteboard copyObject:obj toClipboard:[UIPasteboard generalPasteboard]];
}

+ (void)localCopy:(id)obj {
    CUPasteboard *pasteboard = [[[CUPasteboard alloc] init] autorelease];
    [pasteboard copyObject:obj toClipboard:[UIPasteboard pasteboardWithName:kDefaultLocalPasteboardName create:YES]];
}

- (void)copyObject:(id)obj toClipboard:(UIPasteboard*)board {
    if ([obj isKindOfClass:[NSString class]]) {
        [self copyAudio:(NSString*)obj toClipboard:board];
    } else {
        [self copyDictionary:(NSDictionary*)obj toClipboard:board];
    }
}

- (void)copyDictionary:(NSDictionary*)dictionary toClipboard:(UIPasteboard*)board {
    NSString *path = [dictionary archive];
    [board setValue:path forPasteboardType:(NSString*)kUTTypeUTF8PlainText];
}

- (void)copyAudio:(NSString*)srcPath toClipboard:(UIPasteboard*)board {
    NSString *tmpPath = NSTemporaryDirectory();
	NSString *dstPath = [NSString stringWithFormat:@"%@loopseque.copy.wav", tmpPath];
    
    // Cleanup
    [[NSFileManager defaultManager] removeItemAtPath:dstPath error:NULL];
	// Copy file to temp directory (in case we need write access to the file)
	[[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:dstPath error:NULL];
	
	// Open file as binary data
	NSData *dataFile = [NSData dataWithContentsOfMappedFile:dstPath];
	if (!dataFile) {
        NSLog(@"CUPasteboard: Can't open file");
		return;
	}
	
	// Create chunked data and append to clipboard
	NSUInteger sz = [dataFile length];
	NSUInteger chunkNumbers = (sz / BM_CLIPBOARD_CHUNK_SIZE) + 1;
	NSMutableArray *items = [NSMutableArray arrayWithCapacity:chunkNumbers];
	NSRange curRange;
	
	for (NSUInteger i = 0; i < chunkNumbers; i++) {
		curRange.location = i * BM_CLIPBOARD_CHUNK_SIZE;
		curRange.length = MIN(BM_CLIPBOARD_CHUNK_SIZE, sz - curRange.location);
		NSData *subData = [dataFile subdataWithRange:curRange];
		NSDictionary *dict = [NSDictionary dictionaryWithObject:subData forKey:(NSString*)kUTTypeAudio];
		[items addObject:dict];
	}
	
	board.items = items;
}


#pragma mark Pasting from clipboard

+ (id)paste {
    CUPasteboard *pasteboard = [[[CUPasteboard alloc] init] autorelease];
    UIPasteboard *board      = [UIPasteboard generalPasteboard];
    return [pasteboard audioFromClipBoard:board];
}

+ (id)localPaste {
    CUPasteboard *pasteboard = [[[CUPasteboard alloc] init] autorelease];
    UIPasteboard *board      = [UIPasteboard pasteboardWithName:kDefaultLocalPasteboardName create:NO];
    if (board) {
        return [pasteboard dictionaryFromClipBoard:board];
    }
    return nil;
}

- (NSArray*)dataItemsForType:(NSString*)type fromPasteboard:(UIPasteboard*)board {
    NSArray    *typeArray = [NSArray arrayWithObject:type];
	NSIndexSet *set       = [board itemSetWithPasteboardTypes:typeArray];
	if (!set) {
        NSLog(@"CUPasteboard: Can't get item set");
		return nil;
	}
    // Get the subset of elements
    return [board dataForPasteboardType:type inItemSet:set];
}

- (NSDictionary*)dictionaryFromClipBoard:(UIPasteboard*)board {
    NSString *path = [board valueForPasteboardType:(NSString*)kUTTypeUTF8PlainText];
    NSDictionary *dic = [NSDictionary unacrhive:path];
    return dic;
}

- (NSString*)audioFromClipBoard:(UIPasteboard*)board {
	NSArray *items = [self dataItemsForType:(NSString*)kUTTypeAudio fromPasteboard:board];
    // Write chunks to a temporary file
	if (items) {
		UInt32 cnt = [items count];
		if (!cnt) {
            NSLog(@"CUPasteboard: Nothing to paste");
			return nil;
		}
		
		// Create a file and write each chunks to it.
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp-pasteboard"];
		if (![[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]) {
            NSLog(@"CUPasteboard: Can't create file");
            return nil;
		}
		
		NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
		if (!handle) {
            NSLog(@"CUPasteboard: Can't open file for writing");
			return nil;
		}
		
		// Write each chunk to file
		for (UInt32 i = 0; i < cnt; i++) {
			[handle writeData:[items objectAtIndex:i]];
		}
		[handle closeFile];
		
		//! Quick checks for pasted file recognition
		AudioFileID audioFile = [self openAudioFile:path withWriteAccess:FALSE];
		if (audioFile != nil) {
			[self displayAudioInfo: audioFile];
			[self closeAudioFile: audioFile];
		}
        return path;
	}
    return nil;
}

#pragma mark Audio files metadata manipulation

//! Open an AudioFileID from a file path, display error if any
- (AudioFileID)openAudioFile:(NSString*)path withWriteAccess:(BOOL)writeAccess {
	// Create a NSURL based on a local file
	NSURL *handle = [NSURL fileURLWithPath:path];
	if (handle == nil) {
        NSLog(@"CUPasteboard: NSURL fileURLWithPath failed");
        return nil;
	}
	
	// Get a new AudioFileID
	AudioFileID audioFileID;
	SInt8 perms = writeAccess ? kAudioFileReadWritePermission : kAudioFileReadPermission;
	OSStatus err = AudioFileOpenURL((CFURLRef) handle, perms, 0, &audioFileID);
	if (err != noErr) {
        NSLog(@"CUPasteboard: AudioFileOpenURL failed");
        return nil;
	}
	
	return audioFileID;
}

//! Close an AudioFileID
- (void)closeAudioFile:(AudioFileID)audioFileID {
	AudioFileClose(audioFileID);
}

//! Display all the basic information available from an AudioFileID
- (void)displayAudioInfo:(AudioFileID)audioFileID {
	// Get file format
	AudioFileTypeID typeID;
	UInt32 size = sizeof (AudioFileTypeID);
	OSStatus err = AudioFileGetProperty(audioFileID, kAudioFilePropertyFileFormat, &size, &typeID);
	if (err != noErr) {
        NSLog(@"CUPasteboard: AudioFileGetProperty failed");
		return;
	}
	
	// Get ASBD
	AudioStreamBasicDescription ASBD;
	size = sizeof (AudioStreamBasicDescription);
	err = AudioFileGetProperty(audioFileID, kAudioFilePropertyDataFormat, &size, &ASBD);
	if (err != noErr) {
        NSLog(@"CUPasteboard: AudioFileGetProperty failed");
		return;
	}
    
	// Format basic information
	NSMutableString* fmt = [[NSMutableString alloc] init];
	switch (typeID) {
		case kAudioFileAIFFType: {
			[fmt appendFormat:@"Type: AIFF\nSampling Rate: %.2f\nChannels: %lu", (float) ASBD.mSampleRate, ASBD.mChannelsPerFrame];
		} break;
			
		case kAudioFileWAVEType: {
			[fmt appendFormat:@"Type: WAVE\nSampling Rate: %.2f\nChannels: %lu", (float) ASBD.mSampleRate, ASBD.mChannelsPerFrame];
		} break;
			
		default: {
            [fmt release];
            NSLog(@"CUPasteboard: Not a WAVE of AIFF file");
			return;
		} break;
	}
    
	// Get Name, BPM, ...
	err = AudioFileGetPropertyInfo(audioFileID, kAudioFilePropertyInfoDictionary, &size, NULL);
	if (err != noErr) {
        NSLog(@"CUPasteboard: AudioFileGetPropertyInfo failed");
		[fmt release];
		return;
	}
	CFMutableDictionaryRef infoDict = NULL;
	err = AudioFileGetProperty(audioFileID, kAudioFilePropertyInfoDictionary, &size, &infoDict);
	if (err != noErr) {
        NSLog(@"CUPasteboard: AudioFileGetProperty failed");
		[fmt release];
		return;
	}
	CFDictionaryApplyFunction(infoDict, AddInfoToString, fmt);
	
	// Show info
    NSLog(@"CUPasteboard: %@", fmt);
	[fmt release];
	CFRelease(infoDict);
}

@end
