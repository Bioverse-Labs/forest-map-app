#!/bin/bash

flutter test --coverage
genhtml coverage/lcov.info -o docs/