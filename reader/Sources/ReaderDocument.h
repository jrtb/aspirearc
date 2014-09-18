//
//	ReaderDocument.h
//	Reader v2.6.0
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2013 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface ReaderDocument : NSObject <NSObject, NSCoding>

@property (nonatomic, strong, readonly) NSString *guid;
@property (nonatomic, strong, readonly) NSDate *fileDate;
@property (nonatomic, strong, readwrite) NSDate *lastOpen;
@property (nonatomic, strong, readonly) NSNumber *fileSize;
@property (nonatomic, strong, readonly) NSNumber *pageCount;
@property (nonatomic, strong, readwrite) NSNumber *pageNumber;
@property (nonatomic, strong, readonly) NSMutableIndexSet *bookmarks;
@property (nonatomic, strong, readonly) NSString *fileName;
@property (nonatomic, strong, readonly) NSString *password;
@property (nonatomic, strong, readonly) NSURL *fileURL;

/**
 *  Creates a new instance of ReaderDocument for the PDF document at the specific filePath. If the document has previously been archived, the archived instance will be resored and returned.
 *
 *  @param filePath The absolute filePath of the PDF document you wish to load.
 *  @param phrase   The passphrase used to encrypt the pdf document. use nil if there is no password protection.
 *
 *  @return The ReaderDocument instance created or the unarhived object.
 */
+ (ReaderDocument *)withDocumentFilePath:(NSString *)filePath password:(NSString *)phrase;

/**
 *  Attempts to unarchive a ReaderDocument from the specified filePath.
 *  @warning The filePath parameter *must* be the absolute filePath to the PDF Document. Previous versions allowed you to just specify the name of the PDF document but due to changes in the file system layout of app containers in iOS 8, this is no longer enough.
 *
 *  @param filePath The absolute filePath of the PDF Document you wish to load.
 *  @param phrase   The passphrase used to encrypt the pdf document. use nil if there is no password protection.
 *
 *  @return The ReaderDocument loaded from an archive or nil if there was no archive for this document.
 */
+ (ReaderDocument *)unarchiveFromFilePath:(NSString *)filePath password:(NSString *)phrase;

- (id)initWithFilePath:(NSString *)fullFilePath password:(NSString *)phrase;

- (void)saveReaderDocument;

- (void)updateProperties;

@end

@interface ReaderDocument (Deprecated)

+ (ReaderDocument *)unarchiveFromFileName:(NSString *)filename password:(NSString *)phrase DEPRECATED_MSG_ATTRIBUTE("use narchiveFromFilePath:password: instead");

@end
