subroutine update(app)
end subroutine update

subroutine input(app)
    use sdl2
    use r2d_app

    type(Application) :: app
    type(sdl_event) :: event

    do while (sdl_poll_event(event) > 0)
        select case (event%type)
            case (SDL_QUITEVENT)
                app%isRunning = .false.
        end select
    end do
end subroutine input

subroutine render(app)
    use sdl2
    use r2d_app

    type(Application) :: app
    type(sdl_rect) :: r1
    type(sdl_rect) :: r2
    integer :: rc

    r1 = sdl_rect(50, 50, 100, 100)
    r2 = sdl_rect(200, 200, 100, 100)

    rc = sdl_set_render_draw_color(app%renderer, uint8(0), uint8(0), uint8(0), uint8(SDL_ALPHA_OPAQUE))
    rc = sdl_render_clear(app%renderer)

    rc = sdl_set_render_draw_color(app%renderer, uint8(255), uint8(255), uint8(0), uint8(SDL_ALPHA_OPAQUE))
    rc = sdl_render_fill_rect(app%renderer, r1)
    rc = sdl_set_render_draw_color(app%renderer, uint8(255), uint8(255), uint8(0), uint8(SDL_ALPHA_OPAQUE))
    rc = sdl_render_fill_rect(app%renderer, r2)
end subroutine render

program main
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit, stdout => output_unit
    use :: sdl2
    use :: r2d_app
    implicit none

    type(Application) :: app
    app = Application("Cool game on Rabbit2D", 640, 480)
    app%update => update
    app%input => input
    app%render => render

    call initSDL(app)
    call runApp(app)
end program main
