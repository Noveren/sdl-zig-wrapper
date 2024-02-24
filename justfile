# zig build-lib
#     C:\Users\10791\AppData\Local\zig\p\1220c5360c9c71c215baa41b46ec18d0711059b48416a2b1cf96c7c2d87b2e8e4cf6\src\...
#     -lsetupapi -lwinmm -lgdi32 -limm32 -lversion -loleaut32 -lole32 -ODebug
#     -I C:\Users\10791\AppData\Local\zig\p\1220c5360c9c71c215baa41b46ec18d0711059b48416a2b1cf96c7c2d87b2e8e4cf6\include
#     -DSDL_USE_BUILTIN_OPENGL_DEFINITIONS=1
#     -Mroot -lc
#     --cache-dir D:\Project\sdl2-zig\sdl2\zig-cache
#     --global-cache-dir C:\Users\10791\AppData\Local\zig --name SDL2 -static --listen=-

run name:
    zig build {{name}}_run