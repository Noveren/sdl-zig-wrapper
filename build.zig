
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const sdl2 = b.dependency("sdl2", .{
        .optimize = std.builtin.Mode.ReleaseFast
    }).artifact("SDL2");
    
    const lib = b.addStaticLibrary(.{
        .name = "sdl2",
        .root_source_file = .{.path = "./src/root.zig"},
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibrary(sdl2);
    b.installArtifact(lib);

    const mod = b.addModule("sdl2", .{
        .root_source_file = .{.path = "./src/root.zig"},
    });
    mod.linkLibrary(sdl2);

    example(b, target, optimize, mod, "hello");
}

pub fn example(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.Mode,
    sdl2: *std.Build.Module,
    comptime name: []const u8,
) void {
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = .{.path = "./example/" ++ name ++ ".zig"},
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("sdl2", sdl2);

    const exe_install = b.addInstallArtifact(exe, .{});

    const step = b.step(name, "example");
    step.dependOn(&exe_install.step);

    const exe_run = b.addRunArtifact(exe);
    exe_run.step.dependOn(&exe_install.step);

    const run = b.step(name ++ "_run", "example");
    run.dependOn(&exe_run.step);
}

