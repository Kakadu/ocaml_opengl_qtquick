#include "squircle.h"

#include <QtQuick/qquickwindow.h>
#include <QtGui/QOpenGLShaderProgram>
#include <QtGui/QOpenGLContext>
//#include <QtOpenGL/QGLFunctions>
#include <qglfunctions.h>

#include "kamlo.h"

void Squircle::paint()
{

    CAMLparam0();
/*
    if (!m_program) {
        m_program = new QOpenGLShaderProgram();
        m_program->addShaderFromSourceCode(QOpenGLShader::Vertex,
                                           "attribute highp vec4 vertices;"
                                           "varying highp vec2 coords;"
                                           "void main() {"
                                           "    gl_Position = vertices;"
                                           "    coords = vertices.xy;"
                                           "}");
        m_program->addShaderFromSourceCode(QOpenGLShader::Fragment,
                                           "uniform lowp float t;"
                                           "varying highp vec2 coords;"
                                           "void main() {"
                                           "    lowp float i = 1. - (pow(abs(coords.x), 4.) + pow(abs(coords.y), 4.));"
                                           "    i = smoothstep(t - 0.8, t + 0.8, i);"
                                           "    i = floor(i * 20.) / 20.;"
                                           "    gl_FragColor = vec4(coords * .5 + .5, i, i);"
                                           "}");

        m_program->bindAttributeLocation("vertices", 0);
        m_program->link();

        connect(window()->openglContext(), SIGNAL(aboutToBeDestroyed()),
                this, SLOT(cleanup()), Qt::DirectConnection);
    }
*/


    float values[] = {
         0, 0,
         1, 0,
         0, 1,
    };

    int w = window()->width() ;
    int h = window()->height();
    glViewport(0, 0, w, h);
    //qDebug() << QString("Qt Viewport %1 %2 %3 %4").arg(0).arg(0).arg(w).arg(h);
    glDisable(GL_DEPTH_TEST);

    glClearColor(255, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);

    //glEnable(GL_BLEND);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE);

    #if 0
    glBegin(GL_TRIANGLES);
    glColor3f (0,0,255);
    glVertex3f(0,0,0);
    glVertex3f(1,0,0);
    glVertex3f(0,100,0);
    glEnd();
    #endif

    #if 1
    GLuint vbo;
    glGenBuffers(1, &vbo);
    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(values), values, GL_STATIC_DRAW);
    glDrawArray(GL_TRIANGLES, 0, 3);
    glBindBuffer(GL_ARRAY_BUFFER, vbo, 0);
    #endif
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);


    static value *closure = nullptr;
    if (closure == nullptr) {
      closure = caml_named_value("camlRedraw");
    }
    Q_ASSERT(closure!=nullptr);
    // Uncomment next line to enable OCaml
    //caml_callback(*closure, Val_unit); // should be a unit

    /*
    if (m_program) {
        m_program->disableAttributeArray(0);
        m_program->release();
        }*/

    CAMLreturn0;
}
