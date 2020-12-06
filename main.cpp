#include <cstdio>
#include <thread>
#include <chrono>
#include <stdexcept>

#include <SDL.h>

static void sdl_stuff(void);

int main(int argc, char *argv[]) {
    std::thread sdl_thread(sdl_stuff);
    sdl_thread.detach();
    while(true) {
        using namespace std::chrono_literals;
        std::this_thread::sleep_for(100ms);
    }
    return 0;
}

static void sdl_stuff(void) {
    SDL_Window* window = NULL;
    SDL_Surface* screen = NULL;
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        fprintf(stderr, "could not initialize sdl2: %s\n", SDL_GetError());
        throw std::exception();
    }
    window = SDL_CreateWindow(
            "c_hello",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            640, 480, 0);
    if (window == NULL) {
        fprintf(stderr, "could not create window: %s\n", SDL_GetError());
        throw std::exception();
    }
    screen = SDL_GetWindowSurface(window);
    const Uint32 red = SDL_MapRGB(screen->format, 255, 0, 0);
    SDL_FillRect(screen, NULL, red);
    bool quit = false;
    while (!quit) {
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_QUIT:
                    quit = true;
                    break;
                default: break;
            }
        }
        SDL_UpdateWindowSurface(window);
        SDL_Delay(20);
    }
    SDL_DestroyWindow(window);
    SDL_Quit();
}
