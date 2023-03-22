// Autogenerated from Pigeon (v9.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package dev.flutter.pigeon;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression", "serial"})
public class Pigeon {

  /** Error class for passing custom error details to Flutter via a thrown PlatformException. */
  public static class FlutterError extends RuntimeException {

    /** The error code. */
    public final String code;

    /** The error details. Must be a datatype supported by the api codec. */
    public final Object details;

    public FlutterError(@NonNull String code, @Nullable String message, @Nullable Object details) 
    {
      super(message);
      this.code = code;
      this.details = details;
    }
  }

  @NonNull
  private static ArrayList<Object> wrapError(@NonNull Throwable exception) {
    ArrayList<Object> errorList = new ArrayList<Object>(3);
    if (exception instanceof FlutterError) {
      FlutterError error = (FlutterError) exception;
      errorList.add(error.code);
      errorList.add(error.getMessage());
      errorList.add(error.details);
    } else {
      errorList.add(exception.toString());
      errorList.add(exception.getClass().getSimpleName());
      errorList.add(
        "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    }
    return errorList;
  }

  /**
   * Hello world!
   *
   * Generated class from Pigeon that represents data sent in messages.
   */
  public static final class Hello {
    /** 名字 */
    private @NonNull String name;

    public @NonNull String getName() {
      return name;
    }

    public void setName(@NonNull String setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"name\" is null.");
      }
      this.name = setterArg;
    }

    /** Constructor is private to enforce null safety; use Builder. */
    private Hello() {}

    public static final class Builder {

      private @Nullable String name;

      public @NonNull Builder setName(@NonNull String setterArg) {
        this.name = setterArg;
        return this;
      }

      public @NonNull Hello build() {
        Hello pigeonReturn = new Hello();
        pigeonReturn.setName(name);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(1);
      toListResult.add(name);
      return toListResult;
    }

    static @NonNull Hello fromList(@NonNull ArrayList<Object> list) {
      Hello pigeonResult = new Hello();
      Object name = list.get(0);
      pigeonResult.setName((String) name);
      return pigeonResult;
    }
  }

  public interface Result<T> {
    void success(T result);

    void error(Throwable error);
  }

  private static class HelloHostApiCodec extends StandardMessageCodec {
    public static final HelloHostApiCodec INSTANCE = new HelloHostApiCodec();

    private HelloHostApiCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return Hello.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof Hello) {
        stream.write(128);
        writeValue(stream, ((Hello) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /**
   * host 平台提供的接口
   *
   * Generated interface from Pigeon that represents a handler of messages from Flutter.
   */
  public interface HelloHostApi {
    /** say hello to host api; */
    void sayHelloToHostApi(@NonNull Hello hello);
    /** 异步做工 */
    void doWork(@NonNull Long duration, Result<Void> result);

    /** The codec used by HelloHostApi. */
    static MessageCodec<Object> getCodec() {
      return HelloHostApiCodec.INSTANCE;
    }
    /**Sets up an instance of `HelloHostApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, HelloHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.HelloHostApi.sayHelloToHostApi", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Hello helloArg = (Hello) args.get(0);
                try {
                  api.sayHelloToHostApi(helloArg);
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.HelloHostApi.doWork", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number durationArg = (Number) args.get(0);
                Result<Void> resultCallback =
                    new Result<Void>() {
                      public void success(Void result) {
                        wrapped.add(0, null);
                        reply.reply(wrapped);
                      }

                      public void error(Throwable error) {
                        ArrayList<Object> wrappedError = wrapError(error);
                        reply.reply(wrappedError);
                      }
                    };

                api.doWork((durationArg == null) ? null : durationArg.longValue(), resultCallback);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }

  private static class HelloFlutterApiCodec extends StandardMessageCodec {
    public static final HelloFlutterApiCodec INSTANCE = new HelloFlutterApiCodec();

    private HelloFlutterApiCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return Hello.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof Hello) {
        stream.write(128);
        writeValue(stream, ((Hello) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /**
   * flutter 平台提供的接口
   *
   * Generated class from Pigeon that represents Flutter messages that can be called from Java.
   */
  public static class HelloFlutterApi {
    private final BinaryMessenger binaryMessenger;

    public HelloFlutterApi(BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */     public interface Reply<T> {
      void reply(T reply);
    }
    /** The codec used by HelloFlutterApi. */
    static MessageCodec<Object> getCodec() {
      return HelloFlutterApiCodec.INSTANCE;
    }
    /**
     * say hello to flutter api;
     * - hello 参数
     */
    public void sayHelloToFlutterApi(@NonNull Hello helloArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.HelloFlutterApi.sayHelloToFlutterApi", getCodec());
      channel.send(
          new ArrayList<Object>(Collections.singletonList(helloArg)),
          channelReply -> callback.reply(null));
    }
  }
}
