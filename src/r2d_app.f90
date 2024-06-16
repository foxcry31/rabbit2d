module r2d_app
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit, stdout => output_unit
    use :: sdl2

    implicit none

    type Application
        character(len=25) :: name
        integer :: width
        integer :: height
        procedure (), pointer, nopass :: update => null()
        procedure (), pointer, nopass :: input => null()
        procedure (), pointer, nopass :: render => null()
        type (c_ptr) :: window = c_null_ptr
        type (c_ptr) :: renderer = c_null_ptr
        logical :: isRunning = .true.
    end type Application

contains
    ! other utils subroutines, needs for run function
    subroutine initSDL(app)
        type(Application) :: app

        print "(a)", "Rabbit2D v0.1, SDL 2.0"
        print "(a)", "Debug info here!:"
        print "(a, a)", "Name: ", app%name
        print *, "Width: ", app%width
        print *, "Height: ", app%height

        print "(a)", "Initializating SDL..."

        if (sdl_init(SDL_INIT_VIDEO) < 0) then
            write (stderr, '("SDL Error: ", a)') sdl_get_error()
            stop
        end if

        print "(a)", "Done!"
        print "(a)", "Creating the window..."

        app%window = sdl_create_window(title = app%name // c_null_char, &
            x     = SDL_WINDOWPOS_UNDEFINED, &
            y     = SDL_WINDOWPOS_UNDEFINED, &
            w     = app%width, &
            h     = app%height, &
            flags = SDL_WINDOW_SHOWN)

        if (.not. c_associated(app%window)) then
            write (stderr, '("SDL Error: ", a)') sdl_get_error()
            stop
        end if

        print "(a)", "Done!"
        print "(a)", "Creating the renderer..."

        app%renderer = sdl_create_renderer(app%window, -1, 0)

        print "(a)", "Done!"
        print "(a)", "Engine ready to work!"
    end subroutine initSDL

    subroutine exitApp(app)
        type(Application):: app

        print "(a)", "Goodbye!"

        call sdl_destroy_renderer(app%renderer)
        call sdl_destroy_window(app%window)
        call sdl_quit()
    end subroutine exitApp

    subroutine runApp(app)
        type(Application) :: app

        do while (app%isRunning)
            call app%render
            call app%input
            call app%update

            call sdl_render_present(app%renderer)
            call sdl_delay(20)
        end do

        call exitApp(app)
    end subroutine runApp
end module r2d_app
