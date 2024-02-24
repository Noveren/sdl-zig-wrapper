
const c = @import("c.zig");
const sdl = c.SDL;

pub const Version = extern struct {
    major: u8 = 0, minor: u8 = 0, patch: u8 = 0
};

pub fn get() Version {
    var v = sdl.SDL_version{};
    sdl.SDL_GetVersion(&v);
    return @bitCast(v);
}