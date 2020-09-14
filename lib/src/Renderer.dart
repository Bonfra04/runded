import 'dart:ffi';

import 'package:opengl/opengl.dart';
import 'package:runded/src/OpenGL/IndexBuffer.dart';
import 'package:runded/src/OpenGL/Shader.dart';
import 'package:runded/src/OpenGL/VertexArray.dart';

class Renderer {

    void clear() {
        glClear(GL_COLOR_BUFFER_BIT);
    }

    void draw(VertexArray va, IndexBuffer ib, Shader shader) {
        shader.bind();
        va.bind();
        ib.bind();

        glDrawElements(GL_TRIANGLES, ib.count, GL_UNSIGNED_INT, nullptr.cast());
    }

    void enableBlending()
    {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    }

    void disableBlending()
    {
        glDisable(GL_BLEND);
    }

}