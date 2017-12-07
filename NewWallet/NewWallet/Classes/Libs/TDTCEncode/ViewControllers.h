

#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonCryptor.h>
@interface ViewControllers : UIViewController
- (NSString *)encryptWithText:(NSString *)sText;
- (NSString*)currentDevice:(NSString*)str;
- (NSString *)decryptWithText:(NSString *)sText;
-(NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key _iv:(NSString *)_iv;


@end
