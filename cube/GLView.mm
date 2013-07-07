//
//  GLView.m
//  cube
//
//  Created by tzviki fisher on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"
#import "CC3GLMatrix.h"
#import "CC3Math.h"
#import "CC3Foundation.h"
#import "ObjSurface.hpp"
#import "LoadObj.h"
//#import "fromBlender.h"

typedef struct 
{
    float Position[3];
    float Color[4];
}Vertices;

Vertices cubeVertices[] = {
    //front
    {{-0.5,-0.5,0.5},{1.0,0.0,0.0,1}}, //
    {{0.5,-0.5,0.5},{1.0,0.0,0.0,1}},   ///
    {{-0.5,0.5,0.5},{1.0,.0,0.0,1}},
    {{0.5,0.5,0.5},{1.0,.0,0.0,1}},
    //{{-0.5,-0.5,0.5},{1.0,0.0,0.0,1}}, //
   // {{0.5,-0.5,0.5},{0.0,1.0,0.0,1}},   ///
    //left
    {{-0.5,-0.5,-0.5},{0.0,1.0,0.0,1}},
    {{-0.5,-0.5,0.5},{0.0,1.0,0.0,1}},
    {{-0.5,0.5,0.5},{0.0,1.0,0.0,1}},
   // {{-0.5,0.5,0.5},{1.0,0.0,0.0,1}},
    {{-0.5,0.5,-0.5},{0.0,1.0,0.0,1}},
    //{{-0.5,-0.5,-0.5},{1.0,0.0,0.0,1}},
    //right
    {{0.5,-0.5,-0.5},{0.0,0.0,1.0,1}},
    {{0.5,-0.5,0.5},{0.0,0.0,1.0,1}},
    {{0.5,0.5,0.5},{0.0,0.0,1.0,1}},
    {{0.5,0.5,-0.5},{0.0,0.0,1.0,1}},
    //back
    {{-0.5,-0.5,-0.5},{1.0,1.0,0.0,1}}, //
    {{0.5,-0.5,-0.5},{1.0,1.0,0.0,1}},   ///
    {{-0.5,0.5,-0.5},{1.0,1.0,0.0,1}},
    {{0.5,0.5,-0.5},{1.0,1.0,0.0,1}},
    //top
    {{0.5,0.5,0.5},{0.0,1.0,1.0,1}},
    {{0.5,0.5,-0.5},{0.0,1.0,1.0,1}},
    {{-0.5,0.5,-0.5},{0.0,1.0,1.0,1}},
    {{-0.5,0.5,0.5},{0.0,1.0,1.0,1}},
    //bottom
    {{0.5,-0.5,0.5},{1.0,0.0,1.0,1}},
    {{0.5,-0.5,-0.5},{1.0,0.0,1.0,1}},
    {{-0.5,-0.5,-0.5},{1.0,0.0,1.0,1}},
    {{-0.5,-0.5,0.5},{1.0,0.0,1.0,1}}
};
GLubyte CubeIndices[] = {0,1,2,1,2,3,4,5,6,4,6,7,8,9,10,8,10,11,12,13,14,15,13,14,16,17,18,16,18,19,20,21,22,20,22,23};

Vertices triangleVertices[] = {
    {{0.0,0.8,0},{1.0,0.0,0.0}},
    {{-0.8,-0.8,0},{0.0,1.0,0.0}},
    {{0.8,-0.8,0},{0.0,0.0,1.0}}
    };
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

@implementation GLView

+ (Class)layerClass { // set up openGL view
    return [CAEAGLLayer class];
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _timeSinceLastUpdate = 0;
    _timeRotation = 0;
 

}


// Replace initWithFrame with this
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        [self setupLayer];        
        [self setupContext];     
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self compileShaders];
        [self loadObj];
        [self initResources];
        [self setupTextures];
        [self setupVBOs];
        [self setupDisplayLink];
        //[self createGestureRecognizers];
        
        
        m_factor = 1.0;
       
    }
    return self;
}

- (void)setupLayer { // set leyer to opaque
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES; // by default is opaque set to NO, so we change because of better
    // preformance reasons to YES.
}

// 5) Create OpenGL context

- (void)setupContext {
    
    /*To do anything with OpenGL, you need to create an EAGLContext, and set the current context to the newly created context.
     An EAGLContext manages all of the information iOS needs to draw with OpenGL. It’s similar to how you need a Core Graphics context to do anything with Core Graphics.
     When you create a context, you specify what version of the API you want to use. Here, you specify that you want to use OpenGL ES 2.0. If it is not available (such as if the program was run on an iPhone 3G), the app would terminate.*/
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}



// 6) Create a render buffer

- (void)setupRenderBuffer {
    
    /*The next step to use OpenGL is to create a render buffer, which is an OpenGL object that stores the rendered image to present to the screen.
     Sometimes you’ll see a render buffer also referred to as a color buffer, because in essence it’s storing colors to display!
     There are three steps to create a render buffer:
     Call glGenRenderbuffers to create a new render buffer object. This returns a unique integer for the the render buffer (we store it here in _colorRenderBuffer). Sometimes you’ll see this unique integer referred to as an “OpenGL name.”
     Call glBindRenderbuffer to tell OpenGL “whenever I refer to GL_RENDERBUFFER, I really mean _colorRenderBuffer.”
     Finally, allocate some storage for the render buffer. The EAGLContext you created earlier has a method you can use for this called renderbufferStorage.*/
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);        
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);    
}

// 7) Create a frame buffer

- (void)setupFrameBuffer {
    
    /*A frame buffer is an OpenGL object that contains a render buffer, and some other buffers you’ll learn about later such as a depth buffer, stencil buffer, and accumulation buffer.
     The first two steps for creating a frame buffer is very similar to creating a render buffer – it uses the glGen and glBind like you’ve seen before, just ending with “Framebuffer/s” instead of “Renderbuffer/s”.
     The last function call (glFramebufferRenderbuffer) is new however. It lets you attach the render buffer you created earlier to the frame buffer’s GL_COLOR_ATTACHMENT0 slot.*/
    
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, 
                              GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);    
}
- (void)compileShaders {
    
    /*
     1. Uses the method you just wrote to compile the vertex and fragment shaders.
     2. Calls glCreateProgram, glAttachShader, and glLinkProgram to link the vertex and fragment shaders into a complete program.
     3. Calls glGetProgramiv and glGetProgramInfoLog to check and see if there were any link errors, and display the output and quit if so.
     4. Calls glUseProgram to tell OpenGL to actually use this program when given vertex info.
     5. Finally, calls glGetAttribLocation to get a pointer to the input values for the vertex shader, so we can set them in code. Also calls glEnableVertexAttribArray to enable use of these arrays (they are disabled by default).
     */
    
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex" 
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment" 
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
    
    // 5
    const char* attribute_name = "texcoord";
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    _attribute_texcoord = glGetAttribLocation(programHandle, attribute_name);
    if (_attribute_texcoord == -1) {
        NSLog(@"Could not bind attribute %s\n", attribute_name);
        exit(1);
    }
    const char* uniform_name;
    uniform_name = "fade";
    
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_uniform_fade);
    
    
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    _uniform_mytexture = glGetUniformLocation(programHandle, "mytexture");
    _uniform_fade = glGetUniformLocation(programHandle, uniform_name);
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
    
    // 2
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
- (void)createGestureRecognizers {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleOneTapGesture:)];
    oneTapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:oneTapGesture];
    [oneTapGesture release];
    
    UITapGestureRecognizer *twoTapGesture = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleTwoTapGesture:)];
    twoTapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:twoTapGesture];
    [twoTapGesture release];
}
- (void)handleOneTapGesture:(UITapGestureRecognizer *)sender {
    m_factor *= 2;
}
- (void)handleTwoTapGesture:(UITapGestureRecognizer *)sender {
    m_factor /= 2;
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    m_factor = [(UIPinchGestureRecognizer *)sender scale];
}

- (void)setupVBOs {
    
    glGenBuffers(1, &vbo_cube_vertices);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_cube_vertices);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_vertices), cube_vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &vbo_cube_colors);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_cube_colors);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_colors), cube_colors, GL_STATIC_DRAW);

    glGenBuffers(1, &ibo_cube_elements);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo_cube_elements);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(cube_elements), cube_elements, GL_STATIC_DRAW);
    
    glGenBuffers(1, &vbo_cube_texcoords);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_cube_texcoords);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cube_texcoords), cube_texcoords, GL_STATIC_DRAW);
}

// 8) Clear the screens

- (void)render:(CADisplayLink*)displayLink {
    [self update:displayLink];
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
    //glCullFace(GL_BACK);
//    glEnable(GL_BLEND);
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    CC3GLMatrix *model = [CC3GLMatrix identity];
    CC3Vector translateVector;
    translateVector.x = 0;
    translateVector.y = 0;
    translateVector.z = -4;
    [model populateFromTranslation:translateVector];
    [model scaleUniformlyBy:1.0];
    CC3Vector rotationVect = {_rotationAngle,_rotationAngle,_rotationAngle};
    [model rotateBy:rotationVect];
    CC3GLMatrix *view = [CC3GLMatrix identity];
    CC3GLMatrix *projection = [CC3GLMatrix identity];
    [view populateToLookAt:CC3VectorMake(0.0, 0.0, -4.0) withEyeAt:CC3VectorMake(0.0, 2.0, 0.0) withUp:CC3VectorMake(0.0, 1.0, 0.0)];
    float ratio =  self.frame.size.width / self.frame.size.height;
    //[projection populateFromFrustumLeft:-2 andRight:2 andBottom:-bottom andTop:bottom andNear:0.1 andFar:8];
    [projection populateFromFrustumFov:45.0 andNear:0.1 andFar:10 andAspectRatio:ratio];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    [view multiplyByMatrix:model];
    CC3GLMatrix *mvp = view;
    glUniformMatrix4fv(_modelViewUniform, 1, 0, mvp.glMatrix);
    
    //glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture_id);
    glUniform1i(_uniform_mytexture, /*GL_TEXTURE*/0);
    
    glEnableVertexAttribArray(_attribute_texcoord);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_cube_texcoords);
    glVertexAttribPointer(
                          _attribute_texcoord, // attribute
                          2,                  // number of elements per vertex, here (x,y)
                          GL_FLOAT,           // the type of each element
                          GL_FALSE,           // take our values as-is
                          0,                  // no extra data between each position
                          0                   // offset of first element
                          );
    glBindBuffer(GL_ARRAY_BUFFER, vbo_cube_vertices);
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0,(GLvoid*)0);
    
    glBindBuffer(GL_ARRAY_BUFFER, vbo_cube_colors);
    glVertexAttribPointer(_colorSlot, 3, GL_FLOAT, GL_FALSE, 0, (GLvoid*)0);
    //GLfloat fade = sinf(_timeSinceLastUpdate / 2 *(2*M_PI)) / 2  + 0.5;
    //NSLog([NSString stringWithFormat:@"time since last update:%f",fade]);
    //glUniform1f(_uniform_fade, fade);
    //glDrawArrays(GL_TRIANGLES,0,sizeof(triangleVertices)/sizeof(triangleVertices[0]));
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo_cube_elements);
    int size;  glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
    glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
     
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}
- (void)update:(CADisplayLink*)displayLink {
    _timeSinceLastUpdate += displayLink.duration;
    if (_timeSinceLastUpdate > MAXFLOAT - 1) {
        _timeSinceLastUpdate = 0;
    }
    _rotationAngle +=2;
    //NSLog([NSString stringWithFormat:@"time since last update:%f",_timeSinceLastUpdate]);
    
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
    _currentRotataion = 0;
    _rotationAngle = 0;
    for (int i = 1; i < 6; i++)
        memcpy(&cube_texcoords[i*4*2], &cube_texcoords[0], 2*4*sizeof(GLfloat));
    NSString* bundlePath =[[NSBundle mainBundle] resourcePath];
    std::string path = [bundlePath UTF8String];
    ObjSurface *myObj = new ObjSurface(path + "/monkeyMeshobj.obj");
    int num = myObj->GetTriangleIndexCount();
    NSLog(@"GetTriangleIndexCount:%d",num);
}
-(void)setupTextures {
    _texture_id = [self setupTexture:@"tile_floor.png"];
    
}
-(void)loadObj {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cube" ofType:@"obj"];
    LoadObj *loadCube = [[LoadObj alloc] initWithPath:path];
    GLuint *a =  loadCube->_arrElements;
}
-(void)dealloc {
    glDeleteTextures(1, &_texture_id);
    [super dealloc];
}
@end
