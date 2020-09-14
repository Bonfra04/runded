import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:glfw/glfw.dart';
import 'package:ffi_utils/ffi_utils.dart';
import 'package:opengl/opengl.dart';

class Window {

    Pointer<GLFWwindow> _window;

    Window(int width, int height, String title) {
        initGlfw();
        glfwInit();
        print('GLFW: ${NativeString.fromPointer(glfwGetVersionString())}');

        this._window = glfwCreateWindow(width, height, NativeString.fromString(title), nullptr.cast(), nullptr.cast());
        glfwMakeContextCurrent(this._window);

        initOpenGL();
        int error = glGetError();
        if(error == GL_NO_ERROR)
            print('OpenGL: ${glGetString(GL_VERSION).cast<Utf8>().ref}');
        else
            print('OpenGL error: $error');
    }

    void onUpdate()
    {
        glfwSwapBuffers(this._window);
        glfwPollEvents();
    }

    bool isOpen() => glfwWindowShouldClose(this._window) != GLFW_TRUE;

}