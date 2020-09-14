import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:opengl/opengl.dart';
import 'package:runded/runded.dart';
import 'package:runded/src/Renderer.dart';

import 'package:ffi_utils/ffi_utils.dart';

class Sandbox extends Application {

    Sandbox() : super(1080, 720, "Sandbox");

    final Renderer renderer = Renderer();

    int shader;

    @override
    void onCreate() {
        //this.renderer.enableBlending();

        List<double> pos = [
            -0.5, -0.5,
             0.0,  0.5,
             0.5, -0.5,
        ];

        Pointer<Float> pPos = allocate<Float>(count: pos.length);
        for(int i = 0; i < pos.length; i++)
            pPos.elementAt(i).value = pos[i];

        Pointer<Uint32> buffer = allocate<Uint32>();

        glGenBuffers(1, buffer);
        glBindBuffer(GL_ARRAY_BUFFER, buffer.value);
        glBufferData(GL_ARRAY_BUFFER, 6 * sizeOf<Float>(), pPos, GL_STATIC_DRAW);     
        
        Pointer<Uint32> vao = allocate(); 
        glGenVertexArrays(1, vao);
        glBindVertexArray(vao.value);

        print(vao.value);

        glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * sizeOf<Float>(), 0);
        glEnableVertexAttribArray(0);

        String vs =
"""
#version 330 core

layout(location = 0) in vec4 position;

void main()
{
    gl_Position = position;
}
""";

        String fs =
"""
#version 330 core

layout(location = 0) out vec4 color;

void main()
{
    color = vec4(1.0, 0.0, 0.0, 1.0);
}
""";

        shader = _createShader(vs, fs);
    }

    @override
    void onShutdown() {
    }

    @override
    void onUpdate() {
        glDrawArrays(GL_TRIANGLES, 0, 3);
    }

}

int _compileShader(String source, int type) {
    int id = glCreateShader(type);
    
    Pointer<Pointer<Utf8>> ptr = allocate<Pointer<Utf8>>();
    ptr.elementAt(0).value = NativeString.fromString(source).cast();

    glShaderSource(id, 1, ptr, nullptr);
        glCompileShader(id);
    
    Pointer<Int32> result = allocate<Int32>();
    glGetShaderiv(id, GL_COMPILE_STATUS, result);
    
    if(result.value == GL_FALSE) {
        Pointer<Int32> length = allocate<Int32>();
        glGetShaderiv(id, GL_INFO_LOG_LENGTH, length);

        Pointer<Utf8> message = allocate<Utf8>(count: length.value);
        glGetShaderInfoLog(id, length.value, length, message);
        glDeleteShader(id);

        print("Failed to compile ${type == GL_VERTEX_SHADER ? "vertex" : "fragment"} shader");
        print(message.ref);
        return 0;
    }

    return id;
}

int _createShader(String vertexShader, String fragmentShader) {
    int program = glCreateProgram();
        int vs = _compileShader(vertexShader, GL_VERTEX_SHADER);
    int fs = _compileShader(fragmentShader, GL_FRAGMENT_SHADER);

    glAttachShader(program, vs);
        glAttachShader(program, fs);
        glLinkProgram(program);
        glValidateProgram(program);

    glDeleteShader(vs);
        glDeleteShader(fs);
    
    return program;
} 

void main() => runApp(() => Sandbox());
