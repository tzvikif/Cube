//
//  LoadObj.h
//  cube
//
//  Created by tzviki fisher on 07/07/13.
//
//

#import <Foundation/Foundation.h>
#import "CC3Foundation.h"

@interface LoadObj : NSObject {
@public
    CC3Vector *_arrVertices;
    CC3Vector *_arrVertexNormals;
    GLfloat *_arrTexture;
    GLuint _numberOfFaces;
    GLuint _numberOfVertices;
    GLuint *_arrElements;
    GLubyte	_valuesPerCoord;
}
@property (nonatomic, retain) NSString *sourceObjFilePath;
- (id)initWithPath:(NSString *)path;
- (void)displayArrays;  //for debug.
@end
