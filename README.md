<img src="bioverse.png">

<p align="center">
    <a href="https://github.com/Bioverse-Labs/forest-map-app/actions/workflows/tests.yml" alt="Tests">
        <img src="https://github.com/Bioverse-Labs/forest-map-app/actions/workflows/tests.yml/badge.svg?branch=main" />
    </a>
    <a href="https://github.com/Bioverse-Labs/forest-map-app/issues" alt="Issues">
        <img src="https://img.shields.io/github/issues/Bioverse-Labs/forest-map-app" /></a>
    <a href="https://github.com/Bioverse-Labs/forest-map-app/stargazers" alt="Stars">
        <img src="https://img.shields.io/github/stars/Bioverse-Labs/forest-map-app" /></a>
    <a href="https://github.com/Bioverse-Labs/forest-map-app/forks" alt="Forks">
        <img src="https://img.shields.io/github/forks/Bioverse-Labs/forest-map-app" /></a>
    <a href="https://github.com/Bioverse-Labs/forest-map-app/LICENCE.md" alt="Licence">
        <img src="https://img.shields.io/github/license/Bioverse-Labs/forest-map-app" /></a>
    <a href="https://twitter.com/BioverseLabs" alt="Twitter">
        <img src="https://img.shields.io/twitter/follow/BioverseLabs?label=Follow&style=social" /></a>
</p>

# Bioverse Labs (forest-map-app module)

Designed to serve traditional communities of the amazon rain forest, the Forest Map displays vector files generated from machine learning algorithms designed to locates key tree species from satellite imagery and or UAS. The species' choice is made by the communities and must align with the sustainable and regenerative agroforestry practices and exclude completely any species that have logging appeal.

On the first release, Forest Map TM will allow local cooperatives to use the abundance maps to locate Brazil Nut Tree (Bertholletia excelsa) and Palm Trees. Tree species that contribute to the economic resilience of the riverine communities can be added to future projects when it meets sustainability criteria contributing to increase the value of standing and productive forests.

1. [Setting up your environment](#setting-up-your-environment)
2. [Run](#run)
3. [Tests](#tests)
4. [Architecture ](#architecture)

# Setting up your environment

   <p>
     <a href="https://flutter.dev/docs/get-started/install">https://flutter.dev/docs/get-started/install</a>
   </p>
   
# Run

```
    flutter run lib/main.dart
```

# Tests

### How to run

```
   flutter test
```

#### How to get coverage

```
   sh ./generateCoverage.sh
```

### Coverage Report

     https://bioverse-labs.github.io/forest-map-app/

# Architecture

<p>
    <img src="https://i1.wp.com/resocoder.com/wp-content/uploads/2019/08/CleanArchitecture.jpg?w=772&ssl=1" width="350" /><br/>
    <img src="https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?w=556&ssl=1" width="350" />
</p>

### Firebase

- To run with firebase create a new app on your firebase account and [add your GoogleService to the app](https://firebase.google.com/docs/android/setup).

- To run without firebase just create new adapters implementing the contracts of `AuthAdapter` and `StorageAdapter`. Then remove all firebase dependencies.

#

<a href="https://www.bioverse.io/privacy-policy">Privacy Policy</a>
