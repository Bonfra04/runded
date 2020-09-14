import 'package:opengl/opengl.dart';

class VertexBufferElement {
    int type;
    int count;
    int normalized;

    VertexBufferElement(this.type, this.count, this.normalized);

    static int GetSizeOfType(int type) {
        switch (type)
        {
        case GL_FLOAT:
            return 4;
        case GL_UNSIGNED_INT:
            return 4;
        case GL_UNSIGNED_BYTE:
            return 1;

        default:
            return 0;
        }
    }
}

class VertexBufferLayout {
    
    final List<VertexBufferElement> _elements;
    int _stride;

    List<VertexBufferElement> get elements => this._elements;
    int get stride => this._stride;
    
    VertexBufferLayout() : this._elements = [], this._stride = 0;

    void push_float(int count) {
        this._elements.add(VertexBufferElement(GL_FLOAT, count, GL_FALSE));
        this._stride += VertexBufferElement.GetSizeOfType(GL_FLOAT) * count;
    }

    void push_uint32(int count) {
        this._elements.add(VertexBufferElement(GL_UNSIGNED_INT, count, GL_FALSE));
        this._stride += VertexBufferElement.GetSizeOfType(GL_UNSIGNED_INT) * count;
    }

    void push_uint8(int count) {
        this._elements.add(VertexBufferElement(GL_UNSIGNED_BYTE, count, GL_TRUE));
        this._stride += VertexBufferElement.GetSizeOfType(GL_UNSIGNED_BYTE) * count;
    }

}