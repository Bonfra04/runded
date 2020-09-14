import 'package:glfw/glfw.dart';
import 'package:opengl/opengl.dart';
import 'package:runded/src/Window.dart';

void runApp(Application Function() builder) {
    Application application = builder();
    application.run();

    glfwTerminate();
}

abstract class Application {

    final Window _window;

    Application(int width, int height, String title)
        : this._window = Window(width, height, title);
    
    void run() {
        this.onCreate();

        while (this._window.isOpen())
        {
            this.onUpdate();
            this._window.onUpdate();
            
             glDrawArrays(GL_TRIANGLES, 0, 3);
        }

        this.onShutdown();
    }
    
    void onCreate();
    void onUpdate();
    void onShutdown();
}