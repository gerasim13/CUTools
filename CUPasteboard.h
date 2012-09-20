//
//  CUPasteboard.h
//  Loopseque
//
//  Created by Pavel Litvinenko on 22.04.12.
//  Copyright (c) 2012 Casual Underground. All rights reserved.
//
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

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>

// 10MB max per item in iPhone OS clipboard
#define BM_CLIPBOARD_CHUNK_SIZE (5 * 1024 * 1024)

@interface CUPasteboard : NSObject {
    
}

+ (void)cleanLocalPasteboard;

+ (void)copy:(id)obj;
+ (void)localCopy:(id)obj;

+ (id)paste;
+ (id)localPaste;

- (AudioFileID)openAudioFile:(NSString*) path withWriteAccess:(BOOL)writeAcces;
- (void)closeAudioFile:(AudioFileID)audioFileID;
- (void)displayAudioInfo:(AudioFileID)audioFileID;

@end
