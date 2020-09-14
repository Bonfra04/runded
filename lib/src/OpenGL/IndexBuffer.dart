import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:opengl/opengl.dart';

class IndexBuffer {
    Pointer<Uint32> _id;
    int _count;

    int get count => this._count;

    IndexBuffer(List<int> data, this._count) {
        this._id = allocate<Uint32>();

        Pointer<Uint32> plist = allocate<Uint32>(count: data.length);
        for(int i = 0; i < data.length; i++)
            plist.elementAt(i).value = data[i];

        glGenBuffers(1, this._id);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, this._id.value);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeOf<Uint32>() * data.length, plist, GL_STATIC_DRAW);

        // TODO: Free plist ?
    }

    void destroy() {
        glDeleteBuffers(1, this._id);
        free(this._id);
    }

    void bind() => glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, this._id.value);
    void unbind() => glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}