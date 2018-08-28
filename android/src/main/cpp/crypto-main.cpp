#include <jni.h>
#include <openssl/evp.h>
#include <cstring>
#include <android/log.h>

#define LOGI(...) \
  ((void)__android_log_print(ANDROID_LOG_INFO, "hello-libs::", __VA_ARGS__))

extern "C" JNIEXPORT jstring JNICALL
Java_com_codingfeline_boringsslflutter_BoringsslFlutterPlugin_stringFromJNI(JNIEnv *env, jobject thiz) {
    LOGI("crypto-main#stringFromJNI");

    return env->NewStringUTF("Hello from JNI LIBs!");
}
