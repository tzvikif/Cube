//
//  LoadObj.m
//  cube
//
//  Created by tzviki fisher on 07/07/13.
//
//

#import "LoadObj.h"

@implementation LoadObj

- (id)initWithPath:(NSString *)path {
    NSString *objData= [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSUInteger vertexCount = 0, faceCount = 0, textureCoordsCount=0;
    // Iterate through file once to discover how many vertices, normals, and faces there are
    NSArray *lines = [objData componentsSeparatedByString:@"\n"];
    BOOL firstTextureCoords = YES;
    //NSMutableArray *vertexCombinations = [[NSMutableArray alloc] init];
    for (NSString * line in lines)
    {
        if ([line hasPrefix:@"v "])
            vertexCount++;
        else if ([line hasPrefix:@"vt "])
        {
            textureCoordsCount++;
            if (firstTextureCoords)
            {
                firstTextureCoords = NO;
                NSString *texLine = [line substringFromIndex:3];
                NSArray *texParts = [texLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                _valuesPerCoord = [texParts count];
            }
        }
        else if ([line hasPrefix:@"f"])
        {
            faceCount++;
//            NSString *faceLine = [line substringFromIndex:2];
//            NSArray *faces = [faceLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            for (NSString *oneFace in faces)
//            {
//                NSArray *faceParts = [oneFace componentsSeparatedByString:@"/"];
//                
//                NSString *faceKey = [NSString stringWithFormat:@"%@/%@", [faceParts objectAtIndex:0], ([faceParts count] > 1) ? [faceParts objectAtIndex:1] : 0];
//                if (![vertexCombinations containsObject:faceKey])
//                    [vertexCombinations addObject:faceKey];
//            }
        }
        
    }
    _arrVertices = malloc(sizeof(CC3Vector) *  vertexCount);
    _arrTexture = (textureCoordsCount > 0) ?  malloc(sizeof(GLfloat) * _valuesPerCoord * vertexCount) : NULL;
    GLfloat *allTextureCoords = (textureCoordsCount > 0) ?  malloc(sizeof(GLfloat) * _valuesPerCoord * vertexCount) : NULL;
    _arrVertexNormals =  malloc(sizeof(CC3Vector) *  vertexCount);
    CC3Vector *arrNormalsTemp = malloc(sizeof(CC3Vector) * vertexCount);
    // Store the counts
    _numberOfFaces = faceCount;
    _numberOfVertices = vertexCount;
    GLuint allTextureCoordsCount = 0;
    GLuint normalIndex = 0;
    textureCoordsCount = 0;
    // Reuse our count variables for second time through
    vertexCount = 0;
    NSUInteger lineNum = 0;

    for (NSString * line in lines)
    {
        if ([line hasPrefix:@"v "])
        {
            NSString *lineTrunc = [line substringFromIndex:2];
            NSArray *lineVertices = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            _arrVertices[vertexCount].x = [[lineVertices objectAtIndex:0] floatValue];
            _arrVertices[vertexCount].y = [[lineVertices objectAtIndex:1] floatValue];
            _arrVertices[vertexCount].z = [[lineVertices objectAtIndex:2] floatValue];
            // Ignore weight if it exists..
            vertexCount++;
        }
 
        else if ([line hasPrefix:@"vt "])
        {
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *lineCoords = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            //int coordCount = 1;
            for (NSString *oneCoord in lineCoords)
            {
                allTextureCoords[allTextureCoordsCount] = [oneCoord floatValue];
                //NSLog(@"Setting allTextureCoords[%d] to %f", allTextureCoordsCount, [oneCoord floatValue]);
                allTextureCoordsCount++;
            }
            
            // Ignore weight if it exists..
            textureCoordsCount++;
        }
        else if ([line hasPrefix:@"vn "])
        {
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *lineCoords = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
           
            arrNormalsTemp[normalIndex].x = [[lineCoords objectAtIndex:0] floatValue];
            arrNormalsTemp[normalIndex].y = [[lineCoords objectAtIndex:1] floatValue];
            arrNormalsTemp[normalIndex].z = [[lineCoords objectAtIndex:2] floatValue];
            NSLog(@"normals array:%f,%f,%f",arrNormalsTemp[normalIndex].x,arrNormalsTemp[normalIndex].y,arrNormalsTemp[normalIndex].z);
            normalIndex++;
        }
    }
    GLuint elementIndex = 0;
    GLuint textureIndex = 0;
    normalIndex  = 0;
    _arrElements = malloc(sizeof(GLuint) *  _numberOfFaces * 3 /*3 vertices for each face*/);
    for (NSString * line in lines)
    {
        NSArray *group;
        //f 102//569 156//569 154//569
        if ([line hasPrefix:@"f "])
        {
            NSString *lineTrunc = [line substringFromIndex:2];
            NSArray *groups = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; 
            for (int i=0; i<[groups count]; i++) {
                //  156//571
                group = [[groups objectAtIndex:i] componentsSeparatedByString:@"/"];
                GLuint element = (GLuint)[[group objectAtIndex:0] intValue] - 1;
                _arrElements[elementIndex] = element;
                elementIndex++;
                //_arrElements[elementIndex++] = group[1];
                //_arrElements[elementIndex++] = group[2];
                if (![[group  objectAtIndex:1]  isEqualToString:@""]) {
                    int tempIndex = [[group objectAtIndex:1] intValue] - 1;
                    _arrTexture[textureIndex] = allTextureCoords[tempIndex];
                }
                int tempIndex = [[group objectAtIndex:2] intValue] - 1;
                CC3Vector normal = arrNormalsTemp[tempIndex];
                _arrVertexNormals[normalIndex] = normal;
                normalIndex++;
            }
        }
        
    }
    free(arrNormalsTemp);
    free(allTextureCoords);
    return self;
}
-(void)displayArrays {
    NSLog(@"elemets");
    
}
@end
