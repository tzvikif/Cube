//
//  GLViewController.m
//  cube
//
//  Created by tzvifi on 7/17/13.
//
//

#import "GLViewController.h"
#import "CC3Foundation.h"
#import "CC3Math.h"
#import "CC3GLMatrix.h"
#import "LoadObj.h"
#import "GLView.h"

GLfloat cube_vertices[] = {
    // front
    -1.0, -1.0,  1.0,
    1.0, -1.0,  1.0,
    1.0,  1.0,  1.0,
    -1.0,  1.0,  1.0,
    // top
    -1.0,  1.0,  1.0,
    1.0,  1.0,  1.0,
    1.0,  1.0, -1.0,
    -1.0,  1.0, -1.0,
    // back
    1.0, -1.0, -1.0,
    -1.0, -1.0, -1.0,
    -1.0,  1.0, -1.0,
    1.0,  1.0, -1.0,
    // bottom
    -1.0, -1.0, -1.0,
    1.0, -1.0, -1.0,
    1.0, -1.0,  1.0,
    -1.0, -1.0,  1.0,
    // left
    -1.0, -1.0, -1.0,
    -1.0, -1.0,  1.0,
    -1.0,  1.0,  1.0,
    -1.0,  1.0, -1.0,
    // right
    1.0, -1.0,  1.0,
    1.0, -1.0, -1.0,
    1.0,  1.0, -1.0,
    1.0,  1.0,  1.0,
};
GLfloat cube_colors[] = {
    // front colors
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    // back colors
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
    //
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
    1.0, 1.0, 1.0,
};
GLushort cube_elements[] = {
    // front
    0,  1,  2,
    2,  3,  0,
    // top
    4,  5,  6,
    6,  7,  4,
    // back
    8,  9, 10,
    10, 11,  8,
    // bottom
    12, 13, 14,
    14, 15, 12,
    // left
    16, 17, 18,
    18, 19, 16,
    // right
    20, 21, 22,
    22, 23, 20,
};
GLfloat cube_texcoords[2*4*6] = {
    // front
    0.0, 0.0,
    1.0, 0.0,
    1.0, 1.0,
    0.0, 1.0,
};
GLfloat cube_normals[] = {
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,0.000000,4.000000,
    
    0.000000,4.000000,0.000000,
    
    -0.000000,4.000000,0.000000,
    
    0.000000,4.000000,0.000000,
    
    0.000000,4.000000,0.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    0.000000,0.000000,-4.000000,
    
    -0.000000,-4.000000,0.000000,
    
    0.000000,-4.000000,0.000000,
    
    -0.000000,-4.000000,0.000000,
    
    -0.000000,-4.000000,0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    -4.000000,0.000000,0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    -4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,0.000000,
    
    4.000000,0.000000,-0.000000,
    
    4.000000,0.000000,-0.000000
};

@interface GLViewController ()
@property(nonatomic,assign) CC3Vector rotationVector;
-(CC3Vector)CalculateSurfaceNormal:(CC3Vector*)triangle;
-(CC3Vector)get_arcball_vectorX:(GLuint)x y:(GLuint)y screenW:(GLuint)sw andScreenH:(GLuint)sh;
@end

@implementation GLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self compileShaders];
    [self loadObj];
    [self initResources];
    [self setupTextures];
    [self computeNormals];
    [self setupVBOs];
    [self setupDisplayLink];

}
- (void)compileShaders {
    
    /*
     1. Uses the method you just wrote to compile the vertex and fragment shaders.
     2. Calls glCreateProgram, glAttachShader, and glLinkProgram to link the vertex and fragment shaders into a complete program.
     3. Calls glGetProgramiv and glGetProgramInfoLog ton check and see if there were any link errors, and display the output and quit if so.
     4. Calls glUseProgram to tell OpenGL to actually use this program when given vertex info.
     5. Finally, calls glGetAttribLocation to get a pointer to the input values for the vertex shader, so we can set them in code. Also calls glEnableVertexAttribArray to enable use of these arrays (they are disabled by default).
     */
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex2"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment2"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    [self setProgramHandle:programHandle];
    
    // 5
}
- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
    /*
     1. Gets an NSString with the contents of the file. This is regular old UIKit programming, many of you should be used to this kind of stuff already.
     2. Calls glCreateShader to create a OpenGL object to represent the shader. When you call this function you need to pass in a shaderType to indicate whether it’s a fragment or vertex shader. We take ethis as a parameter to this method.
     3. Calls glShaderSource to give OpenGL the source code for this shader. We do some conversion here to convert the source code from an NSString to a C-string.
     4. Finally, calls glCompileShader to compile the shader at runtime!
     5. This can fail – and it will in practice if your GLSL code has errors in it. When it does fail, it’s useful to get some output messages in terms of what went wrong. This code uses glGetShaderiv and glGetShaderInfoLog to output any error messages to the screen (and quit so you can fix the bug!)
     */
    
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}
-(void)loadObj {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"monkeyMeshobj" ofType:@"obj"];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    LoadObj *loadCube = [[LoadObj alloc] initWithPath:path];
    //[loadCube displayArrays];
    [self setObjLoader:loadCube];
    [loadCube release];
}
- (void)setupVBOs {
    
    CC3Vector *vertices = _objLoader->_arrVertices;
    glGenBuffers(1, &_vbo_cube_vertices);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_vertices);
    glBufferData(GL_ARRAY_BUFFER, sizeof(CC3Vector)*_objLoader->_numberOfVertices, vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vbo_cube_colors);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_colors);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_colors), cube_colors, GL_STATIC_DRAW);
    
    //CC3Vector *normals = _objLoader->_arrNormals;
    glGenBuffers(1, &_vbo_cube_normals);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_normals);
    glBufferData(GL_ARRAY_BUFFER, sizeof(CC3Vector)*_objLoader->_numberOfVertices, _normals, GL_STATIC_DRAW);

    
    GLushort *elements = _objLoader->_arrElements;
    glGenBuffers(1, &_ibo_cube_elements);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo_cube_elements);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*_objLoader->_numberOfFaces*3, elements, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_vbo_cube_texcoords);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_texcoords);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_texcoords), cube_texcoords, GL_STATIC_DRAW);
//    glGenBuffers(1, &_vbo_cube_vertices);
//    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_vertices);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_vertices), cube_vertices, GL_STATIC_DRAW);
//    
//    glGenBuffers(1, &_vbo_cube_colors);
//    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_colors);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_colors), cube_colors, GL_STATIC_DRAW);
//    
//    glGenBuffers(1, &_vbo_cube_normals);
//    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_normals);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_vertices), cube_normals, GL_STATIC_DRAW);
//    
//    glGenBuffers(1, &_ibo_cube_elements);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo_cube_elements);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(cube_elements), cube_elements, GL_STATIC_DRAW);
//    
//    glGenBuffers(1, &_vbo_cube_texcoords);
//    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_texcoords);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_texcoords), cube_texcoords, GL_STATIC_DRAW);

}
- (void)render:(CADisplayLink*)displayLink {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //glEnable(GL_CULL_FACE);
    //glCullFace(GL_BACK);
    //glEnable(GL_BLEND);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    CC3GLMatrix *model = [CC3GLMatrix identity];
    CC3Vector translateVector;
    
    translateVector.x = 0;
    translateVector.y = 0;
    translateVector.z = -4;
    [model populateFromTranslation:translateVector];
    [model scaleUniformlyBy:1.0];
    //CC3Vector rotationVect = {0,0,-1};
    //[model rotateBy:_rotationVector];
    [model rotateAroundAxis:self.rotationVector byAngle:RadiansToDegrees(self.rotationAngle)];
    CC3GLMatrix *view = [CC3GLMatrix identity];
    
    CC3GLMatrix *projection = [CC3GLMatrix identity];
    [view populateToLookAt:CC3VectorMake(0.0, 0.0, -4.0) withEyeAt:CC3VectorMake(1.0, 2.0, 0.0) withUp:CC3VectorMake(0.0, 1.0, 0.0)];
    float ratio =  self.view.frame.size.width / self.view.frame.size.height;
    //[projection populateFromFrustumLeft:-2 andRight:2 andBottom:-bottom andTop:bottom andNear:0.1 andFar:8];
    //[view multiplyByMatrix:model];
    glUniformMatrix4fv(_uHandles.Model, 1, 0, model.glMatrix);
    glUniformMatrix4fv(_uHandles.View, 1, 0, view.glMatrix);
    [projection populateFromFrustumFov:45.0 andNear:0.1 andFar:10 andAspectRatio:ratio];
    glUniformMatrix4fv(_uHandles.Projection, 1, 0, projection.glMatrix);
    [view multiplyByMatrix:model];
    glUniformMatrix4fv(_uHandles.NormalMatrix, 1, 0, view.glMatrix);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture_id);
    glUniform1i(_uHandles.Texture, /*GL_TEXTURE*/0);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_texcoords);
    glVertexAttribPointer(
                          _aHandles.Texcoord, // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          0,                  // no extra data between each position
                          0                   // offset of first element
                          );
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_vertices);
    glVertexAttribPointer(_aHandles.Position, 3, GL_FLOAT, GL_FALSE, 0,(GLvoid*)0);
    
    //glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_colors);
    //glVertexAttribPointer(_aHandles.Color, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)0);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo_cube_normals);
    glVertexAttribPointer(_aHandles.Normal, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)0);
    //GLfloat fade = sinf(_timeSinceLastUpdate / 2 *(2*M_PI)) / 2  + 0.5;
    //NSLog([NSString stringWithFormat:@"time since last update:%f",fade]);
    //glUniform1f(_uniform_fade, fade);
    //glDrawArrays(GL_TRIANGLES,0,sizeof(triangleVertices)/sizeof(triangleVertices[0]));
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ibo_cube_elements);
    int size;  glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
    GLView *v = (GLView*)self.view;
    [v presentRenderbuffer];
    //[_context presentRenderbuffer:GL_RENDERBUFFER];
}
- (void)willRender:(CADisplayLink*)displayLink {
//    _timeSinceLastUpdate += displayLink.duration;
//    if (_timeSinceLastUpdate > MAXFLOAT - 1) {
//        _timeSinceLastUpdate = 0;
//    }
//    if (_rotationAngle > 360) {
//        _rotationAngle -= 360;
//    }
    CC3GLMatrix *matToView,*matToWorld,*matInverted;
    //_rotationAngle +=1;
    //NSLog([NSString stringWithFormat:@"time since last update:%f",_timeSinceLastUpdate]);
    if (_currX != _prevX || _currY != _prevY) {
        CC3Vector va = [self get_arcball_vectorX:_prevX y:_prevY screenW:self.view.frame.size.width andScreenH:self.view.frame.size.height];
        CC3Vector vb = [self get_arcball_vectorX:_currX y:_currY screenW:self.view.frame.size.width andScreenH:self.view.frame.size.height];
        float angle = acos(fmin(1.0f,  CC3VectorDot(va, vb)));
        CC3Vector axis_in_camera_coord = CC3VectorCross(va, vb);
        self.rotationVector = axis_in_camera_coord;
        self.rotationAngle = angle;
        _prevX = _currX;
        _prevY = _currY;
    } 
    [self render:displayLink];
}
- (GLuint)setupTexture:(NSString *)fileName {
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}
-(void)initResources {
    const char* texcoord_name = "texcoord";
    const char* position_name = "Position";
    const char* normal_name = "Normal";
    const char* ambient_name = "AmbientMaterial";
    const char* diffuse_name = "DiffuseMaterial";
    const char* specular_name = "SpecularMaterial";
    const char* shininess_name = "Shininess";
    const char* lightPosition_name = "LightPosition";
    const char* normalMatrix_name = "NormalMatrix";
    //attributes
    //    const char* color_name = "SourceColor";
    _aHandles.Position = glGetAttribLocation(_programHandle,position_name);
    [self checkAttribute:_aHandles.Position name:position_name];
    //    _colorSlot = glGetAttribLocation(programHandle, color_name);
    //    [self checkAttribute:_colorSlot name:color_name];
    _aHandles.Texcoord = glGetAttribLocation(_programHandle, texcoord_name);
    [self checkAttribute:_aHandles.Texcoord name:texcoord_name];
    _aHandles.Normal = glGetAttribLocation(_programHandle, normal_name);
    [self checkAttribute:_aHandles.Normal name:normal_name];
    
    glEnableVertexAttribArray(_aHandles.Position);
    glEnableVertexAttribArray(_aHandles.Texcoord);
    glEnableVertexAttribArray(_aHandles.Normal);
    //    glEnableVertexAttribArray(_colorSlot);
    //uniforms
    _uHandles.Projection = glGetUniformLocation(_programHandle, "Projection");
    _uHandles.Model = glGetUniformLocation(_programHandle, "Model");
    _uHandles.View = glGetUniformLocation(_programHandle, "View");
    _uHandles.Texture = glGetUniformLocation(_programHandle, "mytexture");
    _uHandles.LightPosition = glGetUniformLocation(_programHandle, lightPosition_name);
    [self checkAttribute:_uHandles.LightPosition name:lightPosition_name];
    _uHandles.NormalMatrix = glGetUniformLocation(_programHandle, normalMatrix_name);
    [self checkAttribute:_uHandles.NormalMatrix name:normalMatrix_name];
    _uHandles.Ambient = glGetUniformLocation(_programHandle, ambient_name);
    [self checkAttribute:_uHandles.Ambient name:ambient_name];
    _uHandles.Diffuse = glGetUniformLocation(_programHandle, diffuse_name);
    [self checkAttribute:_uHandles.Diffuse name:diffuse_name];
    _uHandles.Shininess = glGetUniformLocation(_programHandle, shininess_name);
    [self checkAttribute:_uHandles.Shininess name:shininess_name];
    _uHandles.Specular = glGetUniformLocation(_programHandle, specular_name);
    [self checkAttribute:_uHandles.Specular name:specular_name];
    glUniform3f(_uHandles.Ambient, 0.1f, 0.1f, 0.1f);
    glUniform3f(_uHandles.Specular,9.0, 9.0, 0.0);
    glUniform1f(_uHandles.Shininess,60);
    // Set the light position.
    CC3Vector4 lightPosition  = CC3Vector4Make(0.0,1.0,-2.0,0.0);
    glUniform4f(_uHandles.LightPosition, lightPosition.x, lightPosition.y, lightPosition.z,lightPosition.w);
    CC3Vector color = CC3VectorMake(200.0/255.0, 150.0/255.0, 250.0/255.0);
    glUniform3f(_uHandles.Diffuse, color.x, color.y, color.z);
    
    glEnable(GL_DEPTH_TEST);
    _rotationAngle = 0;
    for (int i = 1; i < 6; i++)
        memcpy(&cube_texcoords[i*4*2], &cube_texcoords[0], 2*4*sizeof(GLfloat));
}
- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(willRender:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _timeSinceLastUpdate = 0;
 //   _timeRotation = 0;
    _normals = NULL;
    
    
}
-(void)setupTextures {
    _texture_id = [self setupTexture:@"tile_floor.png"];
    
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadView {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    UIView *v = [[GLView alloc] initWithFrame:screenBounds];
    [self setView:v];
    [v release];
}
- (void)checkAttribute:(GLuint)attribute name:(const char *)name {
    if (attribute == -1) {
        NSLog(@"Could not bind attribute %s\n", name);
        exit(1);
    }
    
}
-(CC3Vector)CalculateSurfaceNormal:(CC3Vector*)triangle {
    CC3Vector p1 = triangle[0];
    CC3Vector p2 = triangle[1];
    CC3Vector p3 = triangle[2];
    
    CC3Vector u = CC3VectorMake(p2.x-p1.x, p2.y-p1.y, p2.z-p1.z);
    CC3Vector v = CC3VectorMake(p3.x-p1.x, p3.y-p1.y, p3.z-p1.z);
    
    CC3Vector normal = CC3VectorCross(u, v);
    return normal;
}
- (void)computeNormals {
    if (_normals != NULL) {
        free(_normals);
    }
    _normals = [self computeNormalsWithElements:_objLoader->_arrElements noe:_objLoader->_numberOfFaces*3 andVertices:(GLfloat*)_objLoader->_arrVertices nov:_objLoader->_numberOfVertices andAverage:YES];
}
/*
- (void)computeNormals {
    if (_normals != NULL) {
        free(_normals);
    }
    CC3Vector normal;
    CC3Vector *vertices = _objLoader->_arrVertices;
    GLushort *elements = _objLoader->_arrElements;
    _normals = (GLfloat*)malloc(sizeof(cube_vertices));
    GLushort *element = cube_elements;
    CC3Vector triangle[3];
    GLushort normalIndex[3];
    for (int i=0; i<sizeof(cube_elements)/sizeof(GLushort); i+=3) {
        int index;
        GLfloat x,y,z;
        for (int j=0; j<3; j++) {
            index = *element;
            normalIndex[j] = index;
            x = cube_vertices[index*3];
            y = cube_vertices[index*3+1];
            z = cube_vertices[index*3+2];
            triangle[j].x = x;
            triangle[j].y = y;
            triangle[j].z = z;
            element++;
        }
        normal = [self CalculateSurfaceNormal:triangle];
        for (int i=0; i<3; i++) {
            _normals[normalIndex[i]*3] = normal.x;
            _normals[normalIndex[i]*3+1] = normal.y;
            _normals[normalIndex[i]*3+2] = normal.z;
        }
       
    }
    [self displayNormals:_normals noe:sizeof(cube_vertices)/(sizeof(GLfloat)*3)];
 
}
*/
- (GLfloat*)computeNormalsWithElements:(GLushort*)elements noe:(GLushort)noe andVertices:(GLfloat*)vertices nov:(GLushort)nov andAverage:(BOOL)average {
    CC3Vector normal;
    GLfloat *normals = (GLfloat*)malloc(sizeof(GLfloat) * nov * 3);
    GLushort *element = elements;
    CC3Vector triangle[3];
    GLushort normalIndex[3];
    for (int i=0; i<noe; i+=3) {
        int index;
        GLfloat x,y,z;
        for (int j=0; j<3; j++) {
            index = *element;
            normalIndex[j] = index;
            x = vertices[index*3];
            y = vertices[index*3+1];
            z = vertices[index*3+2];
            triangle[j].x = x;
            triangle[j].y = y;
            triangle[j].z = z;
            element++;
        }
        normal = [self CalculateSurfaceNormal:triangle];
        for (int i=0; i<3; i++) {
            normals[normalIndex[i]*3] = normal.x;
            normals[normalIndex[i]*3+1] = normal.y;
            normals[normalIndex[i]*3+2] = normal.z;
        }
        
    }
    //[self displayNormals:normals noe:nov];
    //GLfloat *enormals = [self avarageNormalsWithElements:cube_elements numberOfElements:36 andNormals:cube_normals numberOfNormals:24];

    if (average == YES) {
        GLfloat *enormals = [self avarageNormalsWithElements:elements numberOfElements:noe andNormals:normals numberOfNormals:nov];
        free(normals);
        normals = enormals;
    }
    return normals;
}
- (void)displayNormals:(GLfloat*)arr noe:(GLushort)numberOfElements {
    NSLog(@"normals. count:%d",numberOfElements);
    int i;
    NSMutableString *str = [[NSMutableString alloc] init];
    for (i=0; i<numberOfElements*3; i+=3) {
        [str appendFormat:@"\n%f,%f,%f\n",arr[i],arr[i+1],arr[i+2]];
    }
    NSLog(@"%@",str);
}
- (GLfloat*)avarageNormalsWithElements:(GLushort*)arrElements numberOfElements:(GLushort)noe andNormals:(GLfloat*)arrNormals numberOfNormals:(GLushort)non{
    CC3Vector *normalsSum = (CC3Vector*)calloc(non, sizeof(CC3Vector));
    GLushort *normalsCount = (GLushort*)calloc(non, sizeof(GLushort));
    int indexI;
    for (int i=0; i<noe; i++) {
        indexI = arrElements[i];
        CC3Vector currFaceNormal = CC3VectorMake(arrNormals[indexI*3], arrNormals[indexI*3+1], arrNormals[indexI*3+2]);
        normalsSum[indexI] = CC3VectorAdd(normalsSum[indexI], currFaceNormal);
        normalsCount[indexI]++;
//        int indexJ;
//        for (int j=0; j<i; j++) {
//            indexJ = arrElements[j];
//            if (indexJ == indexI) {
//                normalsSum[indexJ] = CC3VectorAdd(normalsSum[indexJ], currFaceNormal);
//                normalsCount[indexJ]++;
//            }
//            
//        }
    }
    for (int i=0; i<non; i++) {
        normalsSum[i] = CC3VectorScaleUniform(normalsSum[i], 1.0/normalsCount[i]);
    }
    //[self displayNormals:(GLfloat*)normalsSum noe:non];
    free(normalsCount);
    return (GLfloat*)normalsSum;
}
#pragma mark -
#pragma mark touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint p = [aTouch locationInView:self.view];
    self.prevX = self.currX = p.x;
    self.prevY = self.currY = p.y;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint currP = [aTouch locationInView:self.view];
    self.currX = currP.x;
    self.currY = currP.y;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
-(CC3Vector)get_arcball_vectorX:(GLuint)x y:(GLuint)y screenW:(GLuint)sw andScreenH:(GLuint)sh {
    CC3Vector P = CC3VectorMake(1.0*x/sw*2 - 1.0, 1.0*y/sh*2 - 1.0, 0);
    P.y = -P.y;
    NSLog(@"x%d y%d",x,y);
    NSLog(@"%f %f %f",P.x,P.y,P.z);
    float OP_squared = P.x * P.x + P.y * P.y;
    if (OP_squared <= 1*1)
        P.z = sqrt(1*1 - OP_squared);  // Pythagore
    else
        P = CC3VectorNormalize(P);  // nearest point
    return P;
}
@end
