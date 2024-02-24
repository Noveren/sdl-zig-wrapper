
const c = @import("c.zig");
const sdl = c.SDL;

/// https://wiki.libsdl.org/SDL2/SDL_Event
pub const EventChecker = struct {
    _current: sdl.SDL_Event = undefined,

    const Self = @This();

    pub fn new() Self { return Self{}; }

    pub const Type = enum(u32) {
        Quit = sdl.SDL_QUIT,
        _,
    };

    pub inline fn getType(self: Self) Type {
        return @enumFromInt(self._current.type);
    }

    pub fn poll(self: *Self) bool {
        return sdl.SDL_PollEvent(&self._current) == 1;
    }
};