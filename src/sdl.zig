const std = @import("std");

pub const c = @cImport(@cInclude("SDL.h"));

pub const Context = struct {
    wnd: ?*c.SDL_Window,

    const Self = @This();

    pub fn init() !Self {
        if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) {
            std.debug.print("{s}\n", .{c.SDL_GetError()});
            return error.SDLInit;
        }
        return Self { .wnd = null };
    }

    pub fn create_window(self: *Self, name: []const u8) !void {
        if (self.wnd != null) return;
        const wnd = c.SDL_CreateWindow(name.ptr,
            c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED,
            640, 480, 0);
        if (wnd == null) {
            std.debug.print("{s}\n", .{c.SDL_GetError()});
            return error.SDLCreateWindow;
        }
        self.wnd = wnd.?;
    }

    pub fn update(self: *Self) !void {
        const r = c.SDL_UpdateWindowSurface(self.wnd);
        if (r != 0) {
            std.debug.print("{s}\n", .{c.SDL_GetError()});
            return error.SDLUpdateWindow;
        }
    }

    pub fn get_screen(self: *Self) !*c.SDL_Surface {
        const screen = c.SDL_GetWindowSurface(self.wnd);
        if (screen == null) {
            std.debug.print("{s}\n", .{c.SDL_GetError()});
            return error.SDLGetWindowSurface;
        }
        return screen;
    }

    pub fn drop(self: *Self) void {
        if (self.wnd != null) c.SDL_DestroyWindow(self.wnd);
        c.SDL_Quit();
    }
};
