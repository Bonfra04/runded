import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:ffi_utils/ffi_utils.dart';

import 'dart:io';

import 'package:opengl/opengl.dart';

class Shader {
    int _id;
    Map<String, int> _uniforms;

    int get program => this._id;

    Shader(String vertexPath, String fragmentPath) {
        String vertexShader = File(vertexPath).readAsStringSync();
        String fragmentShader = File(fragmentPath).readAsStringSync();

        int program = glCreateProgram();
        int vs = Shader._compileShader(GL_VERTEX_SHADER, vertexShader);
        int fs = Shader._compileShader(GL_FRAGMENT_SHADER, fragmentShader);

        glAttachShader(program, vs);
        glAttachShader(program, fs);
        glLinkProgram(program);
        glValidateProgram(program);

        glDeleteShader(vs);
        glDeleteShader(fs);

        this._id = program;
    }

    void destroy() => glDeleteProgram(this._id);

    void bind() => glUseProgram(this._id);
    void unbind() => glUseProgram(0);

    void addUniform(String name) {
        int location = glGetUniformLocation(this._id, NativeString.fromString(name));
        if (location == -1)
            print("Uniform $name not found");
        else
            this._uniforms[name] = location;
    }

    int getUniform(String name) => this._uniforms[name];

    void setUniform1i(String name, int value) {
        int location = this._uniforms[name];
        if(location != null)
            glUniform1i(location, value);
    }

    void setUniform1f(String name, double value) {
        int location = this._uniforms[name];
        if(location != null)
            glUniform1f(location, value);
    }

    /*
    void setUniformMat4f(String name, Matrix4 value) {
        int location = this._uniforms[name];
        if(location != null)
            glUniformMatrix4fv(location, 1, GL_FALSE, );
    }
    */

    static int _compileShader(int type, String source) {
        int id = glCreateShader(type);

        Pointer<Pointer<Utf8>> ptr = allocate<Pointer<Utf8>>();
        ptr.elementAt(0).value = NativeString.fromString(source).cast();
        
        glShaderSource(id, 1, ptr, nullptr);
        glCompileShader(id);

        Pointer<Uint32> result = allocate<Uint32>();
        glGetShaderiv(id, GL_COMPILE_STATUS, result);
        if(result.value == GL_FALSE) {
            Pointer<Uint32> length = allocate<Uint32>();
            glGetShaderiv(id, GL_INFO_LOG_LENGTH, length);
            Pointer<Utf8> message = allocate<Utf8>(count: length.value);
            glGetShaderInfoLog(id, length.value, length, message);
            glDeleteShader(id);

            print("Failed to compile ${type == GL_VERTEX_SHADER ? "vertex" : "fragment"} shader");
            return 0;
        }

        return id;
    }
}