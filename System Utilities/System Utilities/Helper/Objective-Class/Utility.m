//
//  Utility.m
//

#import "Utility.h"

#include <sys/time.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation Utility

+ (NSString*)timeStamp
{
    static time_t last_timestamp = -1;
    static NSMutableSet *nonceHistory = nil;
    
    // Make sure we never send the same timestamp and nonce
    if (!nonceHistory)
        nonceHistory = [[NSMutableSet alloc] init];
    
    struct timeval tv;
    NSString *timestamp, *nonce;
    do {
        // Get the time of day, for both the timestamp and the random seed
        gettimeofday(&tv, NULL);
        
        // Generate a random alphanumeric character sequence for the nonce
        char nonceBytes[16];
        srandom((int)tv.tv_sec | (int)tv.tv_usec);
        for (int i = 0; i < 16; i++) {
            int byte = random() % 62;
            if (byte < 26)
                nonceBytes[i] = 'a' + byte;
            else if (byte < 52)
                nonceBytes[i] = 'A' + byte - 26;
            else
                nonceBytes[i] = '0' + byte - 52;
        }
        
        timestamp = [NSString stringWithFormat:@"%d", (int)tv.tv_sec];
    } while ((tv.tv_sec == last_timestamp) && [nonceHistory containsObject:nonce]);
    
    if (tv.tv_sec != last_timestamp) {
        last_timestamp = tv.tv_sec;
    }
    return timestamp;
}

+ (NSString*)md5:(NSString*)s
{
    const char *cStr = [s UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (int)strlen(cStr), result);
    NSMutableString *results = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [results appendFormat:@"%02x", result[i]];
    }
    return [NSString stringWithString:results];
}

@end
