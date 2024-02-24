//! 统一引入 C 头文件

pub const SDL = @cImport({
    @cInclude("SDL2/SDL.h");
});