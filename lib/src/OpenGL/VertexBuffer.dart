import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:opengl/opengl.dart';

class VertexBuffer {
    Pointer<Uint32> _id;

    VertexBuffer(Pointer<NativeType> data, int size) {
        this._id = allocate<Uint32>();
        glGenBuffers(1, this._id);
        glBindBuffer(GL_ARRAY_BUFFER, this._id.value);
        glBufferData(GL_ARRAY_BUFFER, size, data, GL_STATIC_DRAW);
    }

    void destroy() {
        glDeleteBuffers(1, this._id);
        free(this._id);
    }
    
    void bind() => glBindBuffer(GL_ARRAY_BUFFER, this._id.value);
    void unbind() => glBindBuffer(GL_ARRAY_BUFFER, 0);
}