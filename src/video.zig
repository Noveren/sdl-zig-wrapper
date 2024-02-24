
const sdl = @import("c.zig").SDL;

pub const Color = extern struct {
    r: u8 = 0, g: u8 = 0, b: u8 = 0, a: u8 = 0
};

pub const Rect = extern struct {
    x: c_int, y: c_int, w: c_int, h: c_int
};

pub const Window = struct {
    _ins: *sdl.SDL_Window,

    pub const Err = error {
        FailedToInit,
    };

    pub const Flag = enum(u32) {
        Empty = 0,
        Shown = sdl.SDL_WINDOW_SHOWN,
        FullScreen = sdl.SDL_WINDOW_FULLSCREEN,
        FullScreenDesktop = sdl.SDL_WINDOW_FULLSCREEN_DESKTOP,
        OpenGL = sdl.SDL_WINDOW_OPENGL,
        Vulkan = sdl.SDL_WINDOW_VULKAN,
        Metal  = sdl.SDL_WINDOW_METAL,
        Hidden = sdl.SDL_WINDOW_HIDDEN,
        Borderless = sdl.SDL_WINDOW_BORDERLESS,
        Resizable = sdl.SDL_WINDOW_RESIZABLE,
        MiniMized = sdl.SDL_WINDOW_MINIMIZED,
        Maximized = sdl.SDL_WINDOW_MAXIMIZED,
        InputGrabbed = sdl.SDL_WINDOW_INPUT_GRABBED,
        AllowHighDPI = sdl.SDL_WINDOW_ALLOW_HIGHDPI,
        _,

        pub fn with(self: Flag, flag: Flag) Flag {
            const v: u32 = @intFromEnum(self);
            return @enumFromInt(v | @intFromEnum(flag));
        }
    };

    pub const InitOptions = struct {
        title: [:0]const u8,
        x: c_int = sdl.SDL_WINDOWPOS_CENTERED,
        y: c_int = sdl.SDL_WINDOWPOS_CENTERED,
        w: c_int,
        h: c_int,
        flags: Flag = .Shown,
    };

    pub fn init(opt: InitOptions) Err!Window {
        const v: u32 = if (opt.flags == .Empty) comptime blk: {
            const default = InitOptions{.title = "", .w = 0, .h = 0};
            break :blk @intFromEnum(default.flags);
        } else @intFromEnum(opt.flags);
        const ins = sdl.SDL_CreateWindow(
            opt.title, opt.x, opt.y, opt.w, opt.h, v,
        ) orelse {
            return Err.FailedToInit;
        };
        return Window{._ins = ins};
    }

    pub inline fn deinit(w: Window) void {
        sdl.SDL_DestroyWindow(w._ins);
    }

    pub fn createRenderer(w: Window, opt: Renderer.InitOptions) Renderer.Err!Renderer {
        const v: u32 = if (opt.flags == .Empty) comptime blk: {
            const default = Renderer.InitOptions{};
            break :blk @intFromEnum(default.flags);
        } else @intFromEnum(opt.flags);
        const ins = sdl.SDL_CreateRenderer(
            w._ins, opt.index, v
        ) orelse {
            return Renderer.Err.FailedToInit;
        };
        return Renderer{._ins = ins};
    }
};

pub const Renderer = struct {
    _ins: *sdl.SDL_Renderer,

    pub const Err = error {
        FailedToInit,
        FailedToSetColor,
        FailedToDraw,
    };

    /// the index of the rendering driver to initialize,
    /// or -1 to initialize the first one supporting the requested flags
    pub const InitOptions = struct {
        index: c_int = -1,
        flags: Flag = .Empty,
    };

    pub const Flag = enum(u32) {
        Empty = 0,
        Software = sdl.SDL_RENDERER_SOFTWARE,
        Accelerated = sdl.SDL_RENDERER_ACCELERATED,
        PresentSync = sdl.SDL_RENDERER_PRESENTVSYNC,
        TargetTextrue = sdl.SDL_RENDERER_TARGETTEXTURE,
        _,

        pub fn with(self: Flag, flag: Flag) Flag {
            const v: u32 = @intFromEnum(self);
            return @enumFromInt(v | @intFromEnum(flag));
        }
    };

    pub inline fn deinit(r: Renderer) void {
        sdl.SDL_DestroyRenderer(r._ins);
    }

    pub inline fn present(r: Renderer) void {
        sdl.SDL_RenderPresent(r._ins);
    }

    pub inline fn setColor(r: Renderer, c: Color) Err!void {
        const err = sdl.SDL_SetRenderDrawColor(r._ins, c.r, c.g, c.b, c.a);
        if (err != 0) {
            return Err.FailedToSetColor;
        }
    }

    pub inline fn clear(r: Renderer) Err!void {
        const err = sdl.SDL_RenderClear(r._ins);
        if (err != 0) {
            return Err.FailedToDraw;
        }
    }

    pub inline fn drawRect(r: Renderer, rect: *const Rect) Err!void {
        const err = sdl.SDL_RenderDrawRect(r._ins, @ptrCast(rect));
        if (err != 0) {
            return Err.FailedToDraw;
        }
    }
};

pub const Textrue = struct {

};