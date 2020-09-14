import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:opengl/opengl.dart';
import 'package:runded/src/OpenGL/VertexBuffer.dart';
import 'package:runded/src/OpenGL/VertexBufferLayout.dart';

class VertexArray {
    Pointer<Uint32> _id;

    VertexArray() {
        this._id = allocate<Uint32>();
        glGenVertexArrays(1, this._id);
    }

    void destroy() {
        glDeleteVertexArrays(1, this._id);
        free(this._id);
    } 
    void bind() => glBindVertexArray(this._id.value);
    void unbind() => glBindVertexArray(0);

    void addBuffer(VertexBuffer vb, VertexBufferLayout layout) {
        this.bind();
        vb.bind();
        List<VertexBufferElement> elements = layout.elements;
        int offset = 0;

        for (int i = 0; i < elements.length; i++)
        {
            VertexBufferElement element = elements[i];
            glEnableVertexAttribArray(i);
            glVertexAttribPointer(i, element.count, element.type, element.normalized, layout.stride, offset);
            offset += element.count * VertexBufferElement.GetSizeOfType(element.type);
        }
    }
}