//
//  Linea+Linea_Connect.h
//  acutrax
//
//  Created by Kshitij S. Limaye on 4/19/16.
//
//

#import "LineaSDK.h"

@interface Linea (Connect)

- (void)connectMe:(id)delegate;
- (void)disconnectMe:(id)delegate;

@end
