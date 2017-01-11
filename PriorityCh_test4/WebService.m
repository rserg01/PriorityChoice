//
//  WebService.h
//
//  Created by Manulife on 02/29/12.
//

#import "WebService.h"
#import "Utility.h"

#define DOWNLOAD_FILE_LIMIT 0.5*1024*1024
#define TIMEOUT 10

typedef enum
{
	iWebConnectionTypeDownload,
	iWebConnectionTypeRequest
}iWebConnectionType;

@interface WebService()

@property(nonatomic, retain) NSMutableData *mblData;
@property(nonatomic, assign) NSFileHandle *fileHandle;
@property(nonatomic, retain) NSString *strFileName;
@property(nonatomic, assign) iWebConnectionType requestType;
@property(nonatomic, assign) NSInteger tag;
@property(nonatomic, assign) BOOL isTempFile;

- (void) deleteFile;
- (void) sendError:(NSString *)error;
- (void) sendSuccess;
- (void) fileDownload:(NSString *)url withRequest:(NSString *)request withHeaderFields:(NSDictionary *)headerFields withTag:(NSInteger)tag_;
+ (NSString *)dataFilePath:(NSString *)filename bundle:(BOOL)bundle;
@end


@implementation WebService

@synthesize delegate;
@synthesize mblData;
@synthesize fileHandle;
@synthesize strFileName;
@synthesize requestType;
@synthesize tag;
@synthesize isTempFile;

#pragma mark -
#pragma mark Init
- (id)init 
{
	if ((self = [super init]))
	{
		self.delegate	= nil;
		self.tag		= -1;
		self.strFileName = nil;
		self.fileHandle = nil;
		self.mblData = nil;
	}
	return self;
}

- (void) sendRequest:(NSString *)request toUrl:(NSString *)url withHeaderFields:(NSDictionary *)headerFields withTag:(NSInteger)tag_
{
	self.requestType = iWebConnectionTypeRequest;
	[self fileDownload:url withRequest:request withHeaderFields:headerFields withTag:tag_];	
}

- (void) sendRequest:(NSString *)request withFilename:(NSString *)filename toUrl:(NSString *)url withHeaderFields:(NSDictionary *)headerFields withTag:(NSInteger)tag_
{
	self.requestType = iWebConnectionTypeRequest;
	self.strFileName = [[self class] dataFilePath:filename bundle:NO];
	[self fileDownload:url withRequest:request withHeaderFields:headerFields withTag:tag_];	
}

- (void) fileDownload:(NSString *)url
{
	self.requestType = iWebConnectionTypeDownload;
	[self fileDownload:url withTag:-1];
}

- (void) fileDownload:(NSString *)url withTag:(NSInteger)tag_
{
	self.requestType = iWebConnectionTypeDownload;
	[self fileDownload:url withRequest:nil withHeaderFields:nil withTag:tag_];	
}

- (void) fileDownload:(NSString *)url withFilename:(NSString *)filename withTag:(NSInteger)tag_
{
	self.requestType = iWebConnectionTypeDownload;
	self.strFileName = [[self class] dataFilePath:filename bundle:NO];
	self.isTempFile		= NO;
	[self fileDownload:url withRequest:nil withHeaderFields:nil withTag:tag_];
}

- (void) fileDownload:(NSString *)url withRequest:(NSString *)request withHeaderFields:(NSDictionary *)headerFields withTag:(NSInteger)tag_
{        
	self.tag = tag_;
	//url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"encoded url: >>%@<<", url);
	NSLog(@"request: %@", request);
	NSURL *_url = [NSURL URLWithString:url];
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:_url];
    [theRequest setTimeoutInterval:TIMEOUT];
    
   // NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:_url
   //                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
	
	
	if(self.requestType==iWebConnectionTypeRequest)
	{
		NSLog(@">>Request type is iWebConnectionTypeRequest<<");
		for (NSString *key in [headerFields allKeys]) 
		{
			if(![key isEqualToString:@"Method"])
			{
				[theRequest addValue:[headerFields objectForKey:key] forHTTPHeaderField:key];
			}
		}
		
		NSString *method = [headerFields objectForKey:@"Method"];
		if(method && ![method isEqualToString:@""])
			[theRequest setHTTPMethod:method];
		
		if(request && ![request isEqualToString:@""])
        {
            //[theRequest setHTTPBody:[request dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *requestData = [NSData dataWithBytes:[request UTF8String] length:[request length]];
            [theRequest setHTTPBody:requestData];
            [theRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        }
			
	}
    else
    {
        NSLog(@"not web connection");
    }
	
	NSURLConnection *theConnection= [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];	
	if (theConnection) 
	{
		NSLog(@"Connection start");
		[theConnection start];
	}
	else 
	{
		NSLog(@"ERROR: Connection Failed");
		[self sendError:@"Failed to initialize connection"];
	}
}

- (void) sendSuccess
{	
	NSLog(@"SendSuccess");
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(didCompleteResponse:withTag:)]) 
	{
		if(self.isTempFile)
		{	
			[self.delegate didCompleteResponse:[NSData dataWithContentsOfFile:self.strFileName] withTag:self.tag];			
		}
		else 
		{
			[self.delegate didCompleteResponse:[[self class] stringToData:self.strFileName] withTag:self.tag];
		}		
	}	
	
	if(self.isTempFile)
		[self deleteFile];
}

- (void) sendError:(NSString *)error
{
	[self deleteFile];
	
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectionError:withTag:)]) 
	{
		[self.delegate didConnectionError:error withTag:self.tag];
	}
}

- (void) deleteFile
{
	
	if(self.strFileName && ![self.strFileName isEqualToString:@""])
	{
		//NSLog(@"Deleting %@", self.strFileName);
		NSFileManager *manager = [NSFileManager defaultManager];
		if( [manager fileExistsAtPath:self.strFileName] )
		{
			NSError *error = nil;			
			[manager removeItemAtPath:self.strFileName error:&error];
			if (error != nil) 
			{
				NSLog(@"ERROR: %@", [error localizedDescription]);
			}
		}
	}
}

#pragma mark -
#pragma mark NSURLConnection delegates

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"didReceiveResponse %@", [((NSHTTPURLResponse *)response) allHeaderFields]);
	
	if ([response respondsToSelector:@selector(statusCode)])
	{
		int statusCode = [((NSHTTPURLResponse *)response) statusCode];

		if (statusCode != 200)
		{
			NSLog(@"ERROR: connection returned with status code : %i %@", statusCode, [NSHTTPURLResponse localizedStringForStatusCode:statusCode] );
						
			[self sendError:[NSString stringWithFormat:@"%i - %@", statusCode, [NSHTTPURLResponse localizedStringForStatusCode:statusCode]]];
			[connection cancel];
			return;
		}
		
		
		if (self.strFileName == nil)
		{
			NSString *fileName = [[((NSHTTPURLResponse *)response) allHeaderFields] objectForKey:@"Content-Disposition"];
			//NSLog(@"currentURL : %@",self.currentURL);		
			if (fileName != nil) 
			{
				int start			= [fileName rangeOfString:@"="].location + 1;
				fileName			= [[fileName substringFromIndex:start] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
				self.strFileName	= [[self class] dataFilePath:fileName bundle:NO];
				self.isTempFile		= NO;
				//NSLog(@"fileName: %@, %@", fileName, self.strFileName);
			}
			else 
			{
				//If filename is nil, we assign temporary filename then delete after dowload
				NSDate *currentDateTime = [NSDate date];			
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
				self.strFileName	= [[self class] dataFilePath:[dateFormatter stringFromDate:currentDateTime] bundle:NO];
				[dateFormatter release];
				self.isTempFile		= YES;
				
			}
		}
		
		NSLog(@"fileName : %@",[self.strFileName lastPathComponent]);
	}
	
	if([response expectedContentLength] < 0)
	{
		[connection cancel];
		NSLog(@"ERROR: file download failed");
		[self sendError:@"Please check if the URL is correct"];
	}
	else 
	{	
		[self deleteFile];
		[[NSFileManager defaultManager] createFileAtPath:self.strFileName contents:nil attributes:nil];
		self.fileHandle = [[NSFileHandle fileHandleForWritingAtPath:self.strFileName] retain];				
		self.mblData	= [[NSMutableData alloc] initWithLength:0];		
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

	
	[self.mblData appendData:data];

	if(self.mblData.length > DOWNLOAD_FILE_LIMIT && self.fileHandle!=nil)
	{
		[self.fileHandle writeData:self.mblData];				
		[self.mblData release];	

		self.mblData =[[NSMutableData alloc] initWithLength:0];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"WebService didFailWithError");	
	[connection cancel];
	NSLog(@"ERROR: %@", [error localizedDescription]);
	
	if (self.mblData != nil) 
	{
		[self.mblData release];	
	}
	
	NSLog(@"file handle: %@", self.fileHandle);
	
	if (self.fileHandle != nil) 
	{
		[self.fileHandle closeFile];
		[self.fileHandle release];
	}
	
	NSLog(@"Send error");
	//[self sendError:[NSString stringWithFormat:@"%@ - %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]]];
	[self sendError:[error localizedDescription]];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self.fileHandle writeData:self.mblData];
	
	if (self.mblData != nil) 
	{
		[self.mblData release];	
	}
	if (self.fileHandle != nil) 
	{
		[self.fileHandle closeFile];
		[self.fileHandle release];
	}
	
	//NSLog(@"INFO: File \"%@\" successfully downloaded! with URI %@", self.strFileName, self.currentURL);

	int fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.strFileName error:nil] fileSize];
	if (fileSize > 0) 
	{
		[self sendSuccess];
	}
	else 
	{
		[self sendError:@"Empty file downloaded!"];
	}
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace 
{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
	
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{		//if (... user allows connection despite bad certificate ...)				
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	}			
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}



+ (NSString *)dataFilePath:(NSString *)filename bundle:(BOOL)bundle
{
	if(bundle)
	{
		return [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	}	
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSArray *fileSplit = [filename componentsSeparatedByString:@"/"];
	
	if ([fileSplit count] > 1)
	{
		//create directories 
		NSFileManager *manager = [NSFileManager defaultManager];
		NSError *err;
		NSInteger cntr = 2;
		for (NSString *folder in fileSplit) 
		{
			documentsDirectory = [documentsDirectory stringByAppendingPathComponent:folder];
			[manager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:&err];
			if (cntr == [fileSplit count])
			{
				
				break;
			}
			cntr++;
		}
		filename = [fileSplit objectAtIndex:[fileSplit count]-1];
	}
	
	NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:filename];	
	
	return documentsPath;    
}

#pragma mark -
#pragma mark dealloc
- (void)dealloc 
{
	[self.strFileName release];
	self.delegate = nil;
	[super dealloc];
}

@end
