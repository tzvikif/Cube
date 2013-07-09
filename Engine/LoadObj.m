//
//  LoadObj.m
//  cube
//
//  Created by tzviki fisher on 07/07/13.
//
//

#import "LoadObj.h"
#import "face.h"

@implementation LoadObj

- (id)initWithPath:(NSString *)path {
    NSString *objData= [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSUInteger vertexCount = 0, faceCount = 0, textureCoordsCount=0,normalCount=0;
    // Iterate through file once to discover how many vertices, normals, and faces there are
    NSArray *lines = [objData componentsSeparatedByString:@"\n"];
    BOOL firstTextureCoords = YES;
    NSMutableArray *vertexCombinations = [[NSMutableArray alloc] init];
    NSMutableArray *vertexOrig = [[NSMutableArray alloc] init];
    NSMutableArray *textureOrig = [[NSMutableArray alloc] init];
    NSMutableArray *normalOrig = [[NSMutableArray alloc] init];
    for (NSString * line in lines)
    {
        if ([line hasPrefix:@"v "]) {
            NSString *lineTrunc = [line substringFromIndex:2];
            NSArray *line = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [vertexOrig addObject:line];
            vertexCount++;
        }
        else if ([line hasPrefix:@"vt "])
        {
            NSString *lineTrunc = [line substringFromIndex:3];
            NSArray *line = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [textureOrig addObject:line];
            textureCoordsCount++;
            if (firstTextureCoords)
            {
                _valuesPerCoord = [line count];
            }
        }
        else if ([line hasPrefix:@"vn "]) {
            NSString *lineTrunc = [line substringFromIndex:2];
            NSArray *line = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [normalOrig addObject:line];
            normalCount++;
        }
        else if ([line hasPrefix:@"f"])
        {
            faceCount++;
            NSString *faceLine = [line substringFromIndex:2];
            NSArray *faces = [faceLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            for (NSString *oneFace in faces)
            {
                
                NSArray *arrOneFace = [oneFace componentsSeparatedByString:@"/"];
                Face *faceKey = [[Face alloc] init];
                NSString *strV = [arrOneFace objectAtIndex:0];
                NSString *strVT = [arrOneFace objectAtIndex:1];
                NSString *strN = [arrOneFace objectAtIndex:2];
                [faceKey setV:[strV integerValue]];
                [faceKey setVt:[strVT integerValue]];
                [faceKey setN:[strN integerValue]];
                if (![vertexCombinations containsObject:faceKey])
                    [vertexCombinations addObject:faceKey];
                [faceKey release];
            }
        }
    }
    _arrVertices = malloc(sizeof(CC3Vector) * [vertexCombinations count]);
    _arrTexture = (textureCoordsCount > 0) ?  malloc(sizeof(GLfloat) * _valuesPerCoord * [vertexCombinations count]) : NULL;
    GLfloat *allTextureCoords = (textureCoordsCount > 0) ?  malloc(sizeof(GLfloat) * _valuesPerCoord * vertexCount) : NULL;
    _arrNormals =  malloc(sizeof(CC3Vector) *  [vertexCombinations count]);
    _arrElements = malloc(sizeof(GLuint) * faceCount * 3);
    // Store the counts
    _numberOfFaces = faceCount;
    _numberOfVertices = [vertexCombinations count];
    //GLuint allTextureCoordsCount = 0;
    //GLuint normalIndex = 0;
    GLuint elementIndex = 0;
    GLuint vertexIndex = 0;
    //textureCoordsCount = 0;
    // Reuse our count variables for second time through
    //vertexCount = 0;
    [vertexCombinations release];
    vertexCombinations = [[NSMutableArray alloc] init];
    for (NSString * line in lines)
    {
        if ([line hasPrefix:@"f "])
        {
            NSString *faceLine = [line substringFromIndex:2];
            NSArray *faces = [faceLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            Face *faceKey;
            for (NSString *oneFace in faces)
            {
                NSArray *arrOneFace = [oneFace componentsSeparatedByString:@"/"];
                faceKey = [[Face alloc] init];
                NSString *strV = [arrOneFace objectAtIndex:0];
                NSString *strVT = [arrOneFace objectAtIndex:1];
                NSString *strN = [arrOneFace objectAtIndex:2];
                [faceKey setV:[strV integerValue] - 1];
                [faceKey setVt:[strVT integerValue] - 1];
                [faceKey setN:[strN integerValue] - 1];
                if (![vertexCombinations containsObject:faceKey])
                {
                    CC3Vector vertex;
                    CC3Vector normal;
                    GLfloat u,v;
                    NSArray *vertexTemp = [vertexOrig objectAtIndex:faceKey.v];
                    vertex.x = [[vertexTemp objectAtIndex:0] floatValue];
                    vertex.y = [[vertexTemp objectAtIndex:1] floatValue];
                    vertex.z = [[vertexTemp objectAtIndex:2] floatValue];
                    
                    if (_valuesPerCoord > 1) {
                        NSArray *textureTemp = [textureOrig objectAtIndex:faceKey.vt];
                        u = [[textureTemp objectAtIndex:0] floatValue];
                        v = [[textureTemp objectAtIndex:1] floatValue];
                    }
                    
                    NSArray *normalTemp = [normalOrig objectAtIndex:faceKey.n];
                    normal.x = [[normalTemp objectAtIndex:0] floatValue];
                    normal.y = [[normalTemp objectAtIndex:1] floatValue];
                    normal.z = [[normalTemp objectAtIndex:2] floatValue];
                    
                    _arrVertices[vertexIndex] = vertex;
                    if (!_valuesPerCoord > 1) {
                        _arrTexture[vertexIndex] = u;
                        _arrTexture[vertexIndex+1] = v;
                    }
                    _arrNormals[vertexIndex] = normal;
                    _arrElements[elementIndex] = vertexIndex;
                    
                    vertexIndex++;
                    elementIndex++;
                    
                    [vertexCombinations addObject:faceKey];
                }
                else
                {
                    GLuint index = [vertexCombinations indexOfObject:faceKey];
                    _arrElements[elementIndex] = index;
                    elementIndex++;
                }
               
            }
        [faceKey release];
        }
    }
    
    //free(arrNormalsTemp);
    free(allTextureCoords);
    return self;
}
-(void)displayArrays {
    NSLog(@"elemets");
    int i;
    NSMutableString *str = [[NSMutableString alloc] init];
    for (i=0; i<_numberOfFaces * 3; i+=3) {
        [str appendFormat:@"%d,%d,%d\n",_arrElements[i],_arrElements[i+1],_arrElements[i+2]];
    }
    NSLog(str);
    [str release];
    str = [[NSMutableString alloc] init];
    NSLog(@"vertices");
    
    for (i=0; i<_numberOfVertices; i++) {
        [str appendFormat:@"%f,%f,%f\n",_arrVertices[i].x,_arrVertices[i].y,_arrVertices[i].z];
    }
    NSLog(str);
    [str release];
}
@end
