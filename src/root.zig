
const c = @import("c.zig");
const sdl = c.SDL;

pub const version = @import("version.zig");
pub const video = @import("video.zig");
pub const events = @import("events.zig");

// TODO
pub const log = sdl.SDL_Log;

pub const Flag = enum(u32) {
    Empty = 0,
    Timer = sdl.SDL_INIT_TIMER,
    Audio = sdl.SDL_INIT_AUDIO,
    Video = sdl.SDL_INIT_VIDEO,
    Joystick = sdl.SDL_INIT_JOYSTICK,
    Haptic = sdl.SDL_INIT_HAPTIC,
    Gamecontroller = sdl.SDL_INIT_GAMECONTROLLER,
    Events = sdl.SDL_INIT_EVENTS,
    Everything = sdl.SDL_INIT_EVERYTHING,
    _,

    pub fn with(self: Flag, flag: Flag) Flag {
        const v: u32 = @intFromEnum(self);
        return @enumFromInt(v | @intFromEnum(flag));
    }
};

pub const InitOptions = struct {
    flags: Flag = .Everything,
};

/// 先 SDL_SetMainReady，然后初始化 SDL 库，可选初始化一些子系统
/// 
/// 默认初始化：File IO, Threading
/// 
/// 备注：Message Boxes 可以在没有初始化 Video 子系统时工作
/// 从而当初始化失败时展示错误信息；Log 可以在未初始化时工作；
/// 
/// 示例：try sdl2.init(comptime sdl2.Flag.Empty.with(.Video).with(.Events));
/// 
pub fn init(opt: InitOptions) !void {
    const v: u32 = if (opt.flags == .Empty) comptime blk: {
        const default = InitOptions{};
        break :blk @intFromEnum(default.flags);
    } else @intFromEnum(opt.flags);
    sdl.SDL_SetMainReady();
    if (sdl.SDL_Init(v) < 0) {
        return error.FailedToInitSystem;
    }
}

/// 释放所有被初始化的子系统（资源）
pub inline fn deinit() void {
    sdl.SDL_Quit();
}

// TODO Better
// pub inline fn wasInit(flag: Flag) bool {
//     const v: u32 = @intFromEnum(flag);
//     return sdl.SDL_WasInit(v) == v;
// }