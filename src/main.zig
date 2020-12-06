const std = @import("std");

const sdl = @import("sdl.zig");
const c = sdl.c;

pub fn main() !void {
    var ctx = try sdl.Context.init();
    defer ctx.drop();

    try ctx.create_window("Zig");

    var quit = false;
    while(!quit) {
        var evt: c.SDL_Event = undefined;
        while(c.SDL_PollEvent(&evt) != 0) {
            const ty = evt.@"type";
            switch(ty) {
                c.SDL_QUIT => quit = true,
                else => {},
            }
        }
        try fill_green(&ctx);
        try ctx.update();
        c.SDL_Delay(20);
    }
    std.debug.print("SDL quit\n", .{});
}

fn fill_green(ctx: *sdl.Context) !void {
    var screen = try ctx.get_screen();
    const green = c.SDL_MapRGB(screen.format, 0, 255, 0);
    _ = c.SDL_FillRect(screen, null, green);
    c.SDL_FreeSurface(screen);
}
