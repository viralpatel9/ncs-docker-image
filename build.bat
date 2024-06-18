@echo off

rem

if "%1"=="" goto docker_build
goto local_build

:docker_build

echo Building using Docker

cd
docker run -t -v %cd%:/data -w /data viralpatel9/ncs-docker:master
goto eof

:local_build
echo Building locally is not supported yet
goto:eof


rem --------------------------------------------------------------
:Prepare
rem --------------------------------------------------------------

echo -------------------------------------------------------------
echo ------- Preparing the Build Process -------------------------
echo -------------------------------------------------------------

@echo.
@echo Preparing Building

echo #ifndef COMMIT_H > test-example\commit.h
echo #define COMMIT_H >> test-example\commit.h

git rev-parse --short HEAD > githash
set /p myvar= < githash 
del githash
echo #define SCM_SHA_SHORT  "%myvar%" >> test-example\commit.h

git rev-parse HEAD > githash
set /p myvar= < githash 
del githash
echo #define SCM_SHA_LONG   "%myvar%" >> test-example\commit.h

git rev-parse --abbrev-ref HEAD > githash
set /p myvar= < githash 
del githash
echo #define SCM_BRANCH     "%myvar%" >> test-example\commit.h

git describe > githash
set /p myvar= < githash 
del githash
echo #define SCM_DESCRIBE   "%myvar%" >> source\config\commit.h

echo #endif >> test-example\commit.h

echo "%myvar%" > version.txt

type test-example\commit.h

goto:eof

rem --------------------------------------------------------------
:start
rem --------------------------------------------------------------

rem Prepare
call:Prepare

goto:eof

rem --------------------------------------------------------------
:eof
rem --------------------------------------------------------------