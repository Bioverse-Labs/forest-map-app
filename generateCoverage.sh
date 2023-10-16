#!/bin/bash

flutter test --coverage
lcov --remove coverage/lcov.info '*.g.dart' -o coverage/lcov.info # remove generated files
genhtml coverage/lcov.info -o coverage/html