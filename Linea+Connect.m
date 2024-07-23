//
//  Linea+Linea_Connect.m
//  acutrax
//
//  Created by Kshitij S. Limaye on 4/19/16.
//
//

#import "Linea+Connect.h"

@implementation Linea (Linea_Connect)

- (void)connectMe:(id)delegate {
    [self addDelegate:delegate];
    [self connect];
}

- (void)disconnectMe:(id)delegate {
    [self removeDelegate:delegate];
    [self disconnect];
}
@end
