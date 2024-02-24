
const sdl = @import("sdl2");

pub fn main() !void {
    {
        const v = sdl.version.get();
        sdl.log("SDL Version: %u.%u.%u\n", v.major, v.minor, v.patch);
    }

    try sdl.init(.{});
    defer sdl.deinit();

    const win = try sdl.video.Window.init(.{
        .title = "Titile", .w = 720, .h = 640,
        .flags = comptime sdl.video.Window.Flag.Empty
            .with(.Shown)
    });
    defer win.deinit();

    const renderer = try win.createRenderer(.{});
    defer renderer.deinit();

    const rect = sdl.video.Rect{
        .x = 20, .y = 20, .w = 100, .h = 100
    };

    var e = sdl.events.EventChecker.new();
    var is_go_on = true;
    while (is_go_on) {
        while (e.poll()) {
            switch (e.getType()) {
                .Quit => { is_go_on = false; },
                else => {},
            }
        }

        try renderer.setColor(.{});
        try renderer.clear();

        try renderer.setColor(.{.g = 255});
        try renderer.drawRect(&rect);

        renderer.present();
    }
}