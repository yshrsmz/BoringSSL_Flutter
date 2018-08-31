#include <jni.h>
#include <openssl/evp.h>
#include <cstring>
#include <android/log.h>

#define LOGI(...) \
  ((void)__android_log_print(ANDROID_LOG_INFO, "hello-libs::", __VA_ARGS__))

extern "C"
JNIEXPORT jstring JNICALL
Java_com_codingfeline_boringsslflutter_BoringsslFlutterPlugin_stringFromJNI(JNIEnv *env, jobject thiz) {
    LOGI("crypto-main#stringFromJNI");

    return env->NewStringUTF("Hello from JNI LIBs!");
}

extern "C"
JNIEXPORT jstring JNICALL
Java_com_codingfeline_boringsslflutter_BoringsslFlutterPlugin_getSha512Digest(JNIEnv *env, jobject thiz, jstring target) {
    const char* nativeString = env->GetStringUTFChars(target, JNI_FALSE);
    unsigned char md_value[EVP_MAX_MD_SIZE];
    int md_len, i;

    LOGI("crypto-main#getSha512Digest: %s", nativeString);

    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    const EVP_MD* md = EVP_get_digestbyname("SHA512");

    EVP_DigestInit_ex(ctx, md, EVP_sha512);
    EVP_DigestUpdate(ctx, nativeString, strlen(nativeString));
    EVP_DigestFinal_ex(ctx, md_value, &md_len);

    char result[md_len];

    for (i =0; i < md_len; i++) {
        result[i] = md_value[i];
    }

    return env->NewStringUTF(result);
}
