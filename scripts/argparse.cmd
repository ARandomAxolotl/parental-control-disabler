set "Debuglevel=0"
    :_loop
        if "%~1"=="" goto :_done

        :: ── Full-arg matches first ───────────────────────────────
        if "%~1"=="--skip-check-env" (
            set "Skip_check_env=1"
            shift & goto :_loop
        )
        if "%~1"=="--help" (
            set "Target=HelpMenu"
            shift & goto :_loop
        )
        if "%~1"=="-DD" (
            set "Debuglevel=2"
            shift & goto :_loop
        )
        if "%~1"=="--verbose" (
            set "Debuglevel=2"
            shift & goto :_loop
        )
        if "%~1"=="-D" (
            set "Debuglevel=1"
            shift & goto :_loop
        )

        :: ── Per-character flag parsing ──────────────────────────
        set "_arg=%~1"
        if "!_arg:~0,1!"=="-" (
            set "_c0=!_arg:~1,1!"
            set "_c1=!_arg:~2,1!"

            if /I "!_c0!"=="e" set "Task=Enable"
            if /I "!_c0!"=="s" set "Task=Stop"
            if /I "!_c0!"=="d" set "Task=Disable"
            if /I "!_c0!"=="m" set "Target=MS"
            if /I "!_c0!"=="k" set "Target=Kas"
            if /I "!_c0!"=="b" set "Target=Both"
            if /I "!_c0!"=="h" set "Target=HelpMenu"
            if /I "!_c0!"=="r" set "Target=Remove"

            if /I "!_c1!"=="e" set "Task=Enable"
            if /I "!_c1!"=="s" set "Task=Stop"
            if /I "!_c1!"=="d" set "Task=Disable"
            if /I "!_c1!"=="m" set "Target=MS"
            if /I "!_c1!"=="k" set "Target=Kas"
            if /I "!_c1!"=="b" set "Target=Both"
            if /I "!_c1!"=="h" set "Target=HelpMenu"
            if /I "!_c1!"=="r" set "Target=Remove"
        )

        shift
    goto :_loop

    :_done