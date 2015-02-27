module.exports = function (grunt) {
    "use strict";
    grunt.initConfig({
        // 1.
        // create build web directory
        // create build zip directory that will later contain the zip file to be uploaded to phonegap build service
        mkdir: {
            build: {
                options: {
                    create: ['build/web', 'build/zip']
                }
            }
        },
        // 2.
        // compile dart files
        dart2js: {
            options: {
                // use this to fix a problem into dart2js node module. The module calls dart2js not dart2js.bat.
                // this is needed for Windows. So use the path to your dart2js.bat file
                "dart2js_bin": "C:/dart/dart-sdk/bin/dart2js.bat"
            },
            compile: {
                files: {'build/web/main.dart.js': 'web/main.dart'}
            }
        },
        // 3.
        // copy all needed files, including all needed packages
        // except the .dart files.
        copy: {
            build: {
                files: [
                    {
                        expand: true,
                        src: [
                            'web/!(*.dart)',
                            'web/css/*.css',
                            'web/res/*.svg',
                            'web/packages/angular/**/!(*.dart)',
                            'web/packages/angulardart_swiping_navbar/**/!(*.dart)',
                            'web/packages/browser/**/!(*.dart)',
                            'web/packages/intl/**/!(*.dart)'
                        ],
                        dest: 'build'
                    }
                ]
            }
        },
        // 4.
        // remove empty directories copied using the previous task
        cleanempty: {
            build: {
                options: {
                    files: false
                },
                src: ['build/web/packages/**/*']
            }
        },
        // 5.
        // compress build content to a zip file
        compress: {
            build: {
                options: {
                    archive: 'build/zip/build.zip'
                },
                files: [
                    {
                        expand: true,
                        src: '**/*',
                        cwd: 'build/web/'
                    }
                ]
            }
        },
        // 6.
        // upload the zip to phonegap build
        "phonegap-build": {
            debug: {
                options: {
                    archive: "build/zip/build.zip",
                    "appId": "phonegapBuildAppId",
                    "user": {
                        "email": "adobeAccountEmail",
                        "password": "adobeAccountPassword"
                    }
                }
            }
        }
    });

    require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

    grunt.registerTask('default', [
        'mkdir:build',
        'dart2js',
        'copy:build',
        'cleanempty:build',
        'compress:build',
        'phonegap-build:debug'
    ]);
};