//
//  WebService.h
//
//  Created by Manulife on 02/29/12.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate <NSObject>

@optional
- (void) didCompleteResponse:(NSData *)response withTag:(NSInteger)tag;
- (void) didConnectionError:(NSString *)error withTag:(NSInteger)tag;
- (void) didConnectionError:(NSString *)error withErrorCode:(NSInteger)erroCode withTag:(NSInteger)tag;

@end


@interface WebService : NSObject 
{
	id<WebServiceDelegate> delegate;	
}

@property (nonatomic, assign) id<WebServiceDelegate> delegate;

- (void) sendRequest:(NSString *)request toUrl:(NSString *)url withHeaderFields:(NSDictionary *)headerFields withTag:(NSInteger)tag_;
- (void) sendRequest:(NSString *)request withFilename:(NSString *)filename toUrl:(NSString *)url withHeaderFields:(NSDictionary *)headerFields withTag:(NSInteger)tag_;
- (void) fileDownload:(NSString *)url;
- (void) fileDownload:(NSString *)url withTag:(NSInteger)tag_;
- (void) fileDownload:(NSString *)url withFilename:(NSString *)filename withTag:(NSInteger)tag_;
@end
